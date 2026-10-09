import Link from "next/link";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { ContentEditorForm } from "@/components/content/content-editor-form";
import { requireProfile } from "@/lib/auth";

export default async function NewContentPage() {
  const { profile } = await requireProfile(["counselor"]);

  return (
    <DashboardShell role="counselor" name={profile.full_name}>
      <section className="portal-heading content-editor-heading">
        <div>
          <span>اخبار کنکور</span>
          <h1>نوشتن خبر کنکور</h1>
          <p>خبر را با خلاصه روشن، تاریخ انتشار و لینک منبع معتبر بنویس.</p>
        </div>
        <Link className="button button-ghost" href="/dashboard/counselor/news">
          بازگشت به خبرها
        </Link>
      </section>
      <ContentEditorForm news />
    </DashboardShell>
  );
}
