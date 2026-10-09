import { redirect } from "next/navigation";
import { safeReturnPath } from "@/lib/return-path";
export default async function SignInPage({ searchParams }: { searchParams: Promise<Record<string, string | string[] | undefined>> }) {
  const params = await searchParams;
  const suffix = params.next ? `&next=${encodeURIComponent(safeReturnPath(params.next))}` : "";
  redirect(`/auth?mode=signin${suffix}`);
}
