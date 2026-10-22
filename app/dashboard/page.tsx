import { redirect } from "next/navigation";
import { getDashboardDestination } from "@/lib/auth";
export default async function Dashboard() {
  redirect(await getDashboardDestination());
}
