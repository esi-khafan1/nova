import Link from "next/link";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { requireProfile } from "@/lib/auth";
import {
  contentStatusLabels,
  formatPersianDate,
  type ContentStatus,
} from "@/lib/content";
import { archivePodcastAction } from "./actions";

type ResourceRow = {
  id: string;
  title: string;
  summary: string | null;

  status: ContentStatus;
  updated_at: string;
  published_at: string | null;
};

export default async function CounselorPodcastsPage({
  searchParams,
}: {
  searchParams: Promise<{ saved?: string; error?: string }>;
}) {
  const { supabase, profile } = await requireProfile(["counselor"]);
  const [{ data, error }, params] = await Promise.all([
    supabase
      .from("podcasts")
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
          <span>پادکست‌های نووا</span>
          <h1>پادکست‌های من</h1>
          <p>متن و تصویر بنویس، ویس بارگذاری کن و پادکست را منتشر کن.</p>
        </div>
        <Link className="button" href="/dashboard/counselor/podcasts/new">
          پادکست تازه
        </Link>
      </section>

      {(params.error || error) && (
        <div className="portal-alert error">
          دریافت یا بایگانی پادکست انجام نشد. دوباره تلاش کن.
        </div>
      )}

      {params.saved && (
        <div className="portal-alert success">پادکست با موفقیت ذخیره شد.</div>
      )}

      {!error && resources.length ? (
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
                  <span>پادکست کنکور</span>
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
                    href={`/podcasts/${resource.id}`}
                  >
                    مشاهده
                  </Link>
                )}
                <Link
                  className="button button-secondary button-small"
                  href={`/dashboard/counselor/podcasts/${resource.id}`}
                >
                  ویرایش
                </Link>
                {resource.status !== "archived" && (
                  <form action={archivePodcastAction}>
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
          <h2>هنوز پادکستی ننوشته‌ای</h2>
          <p>اولین پادکستت را با عنوان، متن، تصویر و ویس بساز.</p>
          <Link className="button" href="/dashboard/counselor/podcasts/new">
            نوشتن اولین پادکست
          </Link>
        </section>
      )}
    </DashboardShell>
  );
}
