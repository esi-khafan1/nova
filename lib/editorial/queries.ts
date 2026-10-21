import type { SupabaseClient } from "@supabase/supabase-js";
import { editableSubmission, submissionFields, tableNames, type EditorialKind, type Submission } from "./types";

export async function loadAuthorEditor(supabase: SupabaseClient, kind: EditorialKind, id: string, author: string) {
 const { data, error } = await supabase.from("content_submissions").select(submissionFields).eq("kind",kind).eq("content_id",id).eq("author_id",author).maybeSingle();
 if (error) throw new Error("Unable to load editorial submission");
 const submission = data as Submission | null;
 if (submission) return { data: editableSubmission(submission), submission };
 const { data: live, error: liveError } = await supabase.from(tableNames[kind]).select("*").eq("id",id).eq("author_id",author).maybeSingle();
 if (liveError) throw new Error("Unable to load author content");
 return { data: live ? { ...live, revision: 0 } : null, submission: null };
}
