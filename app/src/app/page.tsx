import { CardStatus } from "@/generated/prisma/enums";
import { db } from "@/lib/db";
import { addCard, deleteCard, moveCard } from "./actions";

// Read the database on every request, not at build time.
export const dynamic = "force-dynamic";

const COLUMNS: { status: CardStatus; label: string }[] = [
  { status: CardStatus.TODO, label: "To do" },
  { status: CardStatus.DOING, label: "Doing" },
  { status: CardStatus.DONE, label: "Done" },
];

export default async function Home() {
  const cards = await db.card.findMany({ orderBy: { createdAt: "asc" } });

  return (
    <main className="mx-auto w-full max-w-4xl p-6">
      <h1 className="mb-4 text-2xl font-semibold">Squared Up</h1>

      <form action={addCard} className="mb-6 flex gap-2">
        <input
          name="title"
          required
          maxLength={100}
          placeholder="New card"
          className="flex-1 rounded border border-gray-300 bg-white px-3 py-2 text-gray-900"
        />
        <button className="rounded bg-black px-4 py-2 text-white">Add</button>
      </form>

      <div className="grid grid-cols-3 gap-4">
        {COLUMNS.map(({ status, label }, index) => (
          <section
            key={status}
            className="rounded bg-gray-100 p-3 text-gray-900"
          >
            <h2 className="mb-2 font-medium">{label}</h2>
            <ul className="space-y-2">
              {cards
                .filter((card) => card.status === status)
                .map((card) => (
                  <li key={card.id} className="rounded bg-white p-3 shadow-sm">
                    <p className="mb-2">{card.title}</p>
                    <div className="flex gap-1 text-sm">
                      {index > 0 && (
                        <form action={moveCard}>
                          <input type="hidden" name="id" value={card.id} />
                          <input type="hidden" name="direction" value="left" />
                          <button className="rounded border px-2">←</button>
                        </form>
                      )}
                      {index < COLUMNS.length - 1 && (
                        <form action={moveCard}>
                          <input type="hidden" name="id" value={card.id} />
                          <input type="hidden" name="direction" value="right" />
                          <button className="rounded border px-2">→</button>
                        </form>
                      )}
                      <form action={deleteCard} className="ml-auto">
                        <input type="hidden" name="id" value={card.id} />
                        <button className="rounded border px-2 text-red-600">
                          ×
                        </button>
                      </form>
                    </div>
                  </li>
                ))}
            </ul>
          </section>
        ))}
      </div>
    </main>
  );
}
