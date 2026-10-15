import type { ReactNode } from "react";
import { LandingHeader } from "@/components/landing-header";
import { createClient } from "@/lib/supabase/server";
import "../landing-approved.css";
import "./magazine-theme.css";

export default async function MagazineLayout({ children }: { children: ReactNode }) {
  const { data: { user } } = await (await createClient()).auth.getUser();
  return <div className="magazine-theme"><LandingHeader isAuthenticated={Boolean(user)} />{children}</div>;
}
