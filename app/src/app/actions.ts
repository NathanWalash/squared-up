"use server";

import { revalidatePath } from "next/cache";
import { CardStatus } from "@/generated/prisma/enums";
import { db } from "@/lib/db";
import { addCardSchema, cardIdSchema, moveCardSchema } from "@/lib/schemas";

const ORDER: CardStatus[] = [
  CardStatus.TODO,
  CardStatus.DOING,
  CardStatus.DONE,
];

export async function addCard(formData: FormData) {
  const { title } = addCardSchema.parse(Object.fromEntries(formData));
  await db.card.create({ data: { title } });
  revalidatePath("/");
}

export async function moveCard(formData: FormData) {
  const { id, direction } = moveCardSchema.parse(Object.fromEntries(formData));
  const card = await db.card.findUnique({ where: { id } });
  if (!card) return;

  const step = direction === "right" ? 1 : -1;
  const next = ORDER[ORDER.indexOf(card.status) + step];
  if (!next) return;

  await db.card.update({ where: { id }, data: { status: next } });
  revalidatePath("/");
}

export async function deleteCard(formData: FormData) {
  const { id } = cardIdSchema.parse(Object.fromEntries(formData));
  await db.card.deleteMany({ where: { id } });
  revalidatePath("/");
}
