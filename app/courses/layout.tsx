import type { ReactNode } from "react";
import { LandingHeader } from "@/components/landing-header";
import { createClient } from "@/lib/supabase/server";
import "../landing-approved.css";
import "../mag/magazine-theme.css";
import "./course-pages.css";

export default async function CoursesLayout({ children }: { children: ReactNode }) {
  const { data: { user } } = await (await createClient()).auth.getUser();
  return <div className="magazine-theme course-pages"><LandingHeader isAuthenticated={Boolean(user)} />{children}</div>;
}
