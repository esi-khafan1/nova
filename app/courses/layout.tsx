import type { ReactNode } from "react";
import { LandingHeader } from "@/components/landing-header";
import { getRequestUser } from "@/lib/supabase/request-auth";
import "../landing-approved.css";
import "../mag/magazine-theme.css";
import "./course-pages.css";

export default async function CoursesLayout({ children }: { children: ReactNode }) {
  const { user } = await getRequestUser();
  return <div className="magazine-theme course-pages"><LandingHeader isAuthenticated={Boolean(user)} />{children}</div>;
}
