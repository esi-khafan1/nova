import Link from "next/link";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { requireProfile } from "@/lib/auth";
import {
  contentStatusLabels,
  formatPersianDate,
  type ContentStatus,
} from "@/lib/content";
import { archiveNewsAction } from "./actions";

type ResourceRow = {
  id: string;
  title: string;
  summary: string | null;

  status: ContentStatus;
  updated_at: string;
  published_at: string | null;
};

export default async function CounselorNewsPage({
  searchParams,
}: {
  searchParams: Promise<{ saved?: string; error?: string }>;
}) {
  const { supabase, profile } = await requireProfile(["counselor"]);
  const [{ data }, params] = await Promise.all([
    supabase
      .from("konkur_news")
      .select("id,title,summary,status,updated_at,published_at")
      .eq("author_id", profile.id)
      .order("updated_at", { ascending: false }),
    searchParams,
  ]);
  const resources = (data ?? []) as ResourceRow[];

  return (
    <DashboardShell role="counselor" name={profile.full_name}>
      <section className="portal-heading content-dashboard-heading">
        <div>
          <span>اخبار کنکور</span>
          <h1>خبرهای کنکور من</h1>
          <p>خبر معتبر بنویس، منبع آن را ثبت کن و برای دانش‌آموزان منتشر کن.</p>
        </div>
        <Link className="button" href="/dashboard/counselor/news/new">
          خبر تازه
        </Link>
      </section>

      {params.error && (
        <div className="portal-alert error">
          بایگانی خبر انجام نشد. دوباره تلاش کن.
        </div>
      )}

      {params.saved && (
        <div className="portal-alert success">خبر با موفقیت ذخیره شد.</div>
      )}

      {resources.length ? (
        <div className="content-dashboard-list">
          {resources.map((resource) => (
            <article
              className="portal-card content-dashboard-item"
              key={resource.id}
            >
              <div>
                <div className="content-dashboard-meta">
                  <span className={`content-status ${resource.status}`}>
                    {contentStatusLabels[resource.status]}
                  </span>
                  <span>خبر کنکور</span>
                  <span>
                    {formatPersianDate(
                      resource.published_at ?? resource.updated_at,
                    )}
                  </span>
                </div>
                <h2>{resource.title}</h2>
                {resource.summary && <p>{resource.summary}</p>}
              </div>
              <div className="content-dashboard-actions">
                {resource.status === "published" && (
                  <Link
                    className="button button-ghost button-small"
                    href={`/news/${resource.id}`}
                  >
                    مشاهده
                  </Link>
                )}
                <Link
                  className="button button-secondary button-small"
                  href={`/dashboard/counselor/news/${resource.id}`}
                >
                  ویرایش
                </Link>
                {resource.status !== "archived" && (
                  <form action={archiveNewsAction}>
                    <input name="id" type="hidden" value={resource.id} />
                    <button className="content-archive-button" type="submit">
                      بایگانی
                    </button>
                  </form>
                )}
              </div>
            </article>
          ))}
        </div>
      ) : (
        <section className="portal-card portal-empty content-empty">
          <div className="portal-empty-icon">✎</div>
          <h2>هنوز خبری ننوشته‌ای</h2>
          <p>اولین خبرت را با عنوان، متن و لینک منبع معتبر بنویس.</p>
          <Link className="button" href="/dashboard/counselor/news/new">
            نوشتن اولین خبر
          </Link>
        </section>
      )}
    </DashboardShell>
  );
}
