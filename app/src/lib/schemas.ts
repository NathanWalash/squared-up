import { z } from "zod";

export const addCardSchema = z.object({
  title: z.string().trim().min(1, "Title is required").max(100),
});

export const cardIdSchema = z.object({
  id: z.coerce.number().int().positive(),
});

export const moveCardSchema = cardIdSchema.extend({
  direction: z.enum(["left", "right"]),
});
