import { revalidatePath } from "next/cache";
import { authorPaths, publicPaths, type EditorialKind } from "./types";
export function refreshEditorial(kind: EditorialKind,id?: string) {
 for (const path of ["/","/sitemap.xml","/dashboard/counselor","/dashboard/content_manager",`/dashboard/counselor/${authorPaths[kind]}`,`/${publicPaths[kind]}`]) revalidatePath(path);
 if(id) { revalidatePath(`/${publicPaths[kind]}/${id}`); revalidatePath(`/dashboard/counselor/${authorPaths[kind]}/${id}`); }
}

export function refreshSubmission(kind: EditorialKind,id?: string) {
 for(const path of ["/dashboard/counselor","/dashboard/content_manager",`/dashboard/counselor/${authorPaths[kind]}`]) revalidatePath(path);
 if(id) revalidatePath(`/dashboard/counselor/${authorPaths[kind]}/${id}`);
}
