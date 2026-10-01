import Link from "next/link";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { requireProfile } from "@/lib/auth";
import {
  contentStatusLabels,
  formatPersianDate,
  resourceTypeLabels,
  type ContentStatus,
  type ResourceType,
} from "@/lib/content";
import { archiveResourceAction } from "./actions";

type ResourceRow = {
  id: string;
  title: string;
  summary: string | null;
  resource_type: ResourceType;
  status: ContentStatus;
  updated_at: string;
  published_at: string | null;
};

export default async function CounselorContentPage({
  searchParams,
}: {
  searchParams: Promise<{ saved?: string }>;
}) {
  const { supabase, profile } = await requireProfile(["counselor"]);
  const [{ data }, params] = await Promise.all([
    supabase
      .from("resources")
      .select("id,title,summary,resource_type,status,updated_at,published_at")
      .eq("author_id", profile.id)
      .order("updated_at", { ascending: false }),
    searchParams,
  ]);
  const resources = (data ?? []) as ResourceRow[];

  return (
    <DashboardShell role="counselor" name={profile.full_name}>
      <section className="portal-heading content-dashboard-heading">
        <div>
          <span>استودیوی محتوا</span>
          <h1>محتواهای آموزشی من</h1>
          <p>
            مقاله بنویس، تصویر اضافه کن و همان لحظه برای دانش‌آموزان منتشر کن.
          </p>
        </div>
        <Link className="button" href="/dashboard/counselor/content/new">
          محتوای تازه
        </Link>
      </section>

      {params.saved && (
        <div className="portal-alert success">محتوا با موفقیت ذخیره شد.</div>
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
                  <span>{resourceTypeLabels[resource.resource_type]}</span>
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
                    href={`/mag/${resource.id}`}
                  >
                    مشاهده
                  </Link>
                )}
                <Link
                  className="button button-secondary button-small"
                  href={`/dashboard/counselor/content/${resource.id}`}
                >
                  ویرایش
                </Link>
                {resource.status !== "archived" && (
                  <form action={archiveResourceAction}>
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
          <h2>هنوز محتوایی ننوشته‌ای</h2>
          <p>اولین مقاله‌ات را با یک عنوان روشن و چند نکته کاربردی شروع کن.</p>
          <Link className="button" href="/dashboard/counselor/content/new">
            نوشتن اولین محتوا
          </Link>
        </section>
      )}
    </DashboardShell>
  );
}
