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
          <span>استودیوی محتوا</span>
          <h1>نوشتن محتوای تازه</h1>
          <p>
            یک موضوع مشخص انتخاب کن و مطلب را کوتاه، بخش‌بندی‌شده و کاربردی
            بنویس.
          </p>
        </div>
        <Link
          className="button button-ghost"
          href="/dashboard/counselor/content"
        >
          بازگشت به محتواها
        </Link>
      </section>
      <ContentEditorForm />
    </DashboardShell>
  );
}
