"use server";
import { saveAuthorSubmission } from "@/lib/editorial/save";
export type ContentActionState = { error?: string };
export async function saveResourceAction(_previousState: ContentActionState,form: FormData): Promise<ContentActionState> {
 return saveAuthorSubmission("resources",form);
}
