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
          <span>پادکست‌های نووا</span>
          <h1>ساخت پادکست</h1>
          <p>عنوان، متن و تصویر را اضافه کن؛ سپس ویس را بارگذاری و منتشر کن.</p>
        </div>
        <Link
          className="button button-ghost"
          href="/dashboard/counselor/podcasts"
        >
          بازگشت به پادکست‌ها
        </Link>
      </section>
      <ContentEditorForm podcast />
    </DashboardShell>
  );
}
