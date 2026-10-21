import type { ReactNode } from "react";
import { LandingHeader } from "@/components/landing-header";
import { getRequestUser } from "@/lib/supabase/request-auth";
import "../landing-approved.css";
import "./magazine-theme.css";

export default async function MagazineLayout({ children }: { children: ReactNode }) {
  const { user } = await getRequestUser();
  return <div className="magazine-theme"><LandingHeader isAuthenticated={Boolean(user)} />{children}</div>;
}
