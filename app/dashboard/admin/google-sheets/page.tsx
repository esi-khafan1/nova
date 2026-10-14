import { requireProfile } from "@/lib/auth";
import { redirect } from "next/navigation";
export default async function RetiredSheetSettings(){
 await requireProfile(["admin"]);
 redirect("/dashboard/admin/registrations");
}
