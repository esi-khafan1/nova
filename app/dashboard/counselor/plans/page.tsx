import {loadPlannerEditorCapability} from "@/lib/planner-editor-capability";
import {loadCounselorEditorPage, type CounselorPlanHistory} from "@/lib/load-counselor-plans";
import {getRequestClient} from "@/lib/supabase/request-auth";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import {
  WeeklyPlanBuilder,
  type CounselorWeeklyPlan,
} from "@/components/dashboard/weekly-plan-builder";
import { requireProfile } from "@/lib/auth";
import type { StudyField } from "@/lib/study-catalog";

type StudentDirectoryRow = {
  student_id: string;
  full_name: string;
  grade: number | null;
  study_field: StudyField | null;
  is_selected: boolean;
};

export default async function CounselorPlansPage({
  searchParams,
}: {
  searchParams: Promise<Record<string, string | undefined>>;
}) {
  // All reads derive their identity from auth.uid() and enforce their existing
  // role/RLS guards. Never render results before fresh Auth succeeds.
  const supabase = await getRequestClient();
  const [{profile},params,{data:directoryData,error:directoryError},loadedPlans,loadedHistory,{data:completedRows,error:completedError},capability]=await Promise.all([
    requireProfile(["counselor"]),
    searchParams,
    supabase.rpc("counselor_student_directory"),
    loadCounselorEditorPage<CounselorWeeklyPlan>(supabase,false).then(data=>({data,failed:false}),()=>({data:null,failed:true})),
    loadCounselorEditorPage<CounselorPlanHistory>(supabase,true).then(data=>({data,failed:false}),()=>({data:null,failed:true})),
    supabase.rpc("counselor_completed_plan_item_ids"),
    loadPlannerEditorCapability(supabase).then(data=>({data,failed:false}),()=>({data:false,failed:true})),
  ]);
  if(directoryError||!Array.isArray(directoryData)||loadedPlans.failed||loadedHistory.failed||!loadedPlans.data||!loadedHistory.data||
    capability.failed||loadedPlans.data.counselorId!==profile.id||loadedHistory.data.counselorId!==profile.id||completedError||!Array.isArray(completedRows))return <DashboardShell role="counselor" name={profile.full_name}><section className="portal-card portal-alert error" role="alert"><h1>اطلاعات برنامه‌ها دریافت نشد</h1><p>برای جلوگیری از ذخیرهٔ ناقص، فرم فعلاً نمایش داده نمی‌شود. دوباره صفحه را باز کن.</p></section></DashboardShell>;

  const directory = directoryData as StudentDirectoryRow[];
  const selectedStudents = directory.filter((student) => student.is_selected);
  const counselorPlans = loadedPlans.data.plans;
  const recentPlans = [...new Map([...loadedHistory.data.plans,...counselorPlans.filter(plan=>plan.status==="published"||plan.status==="draft").map(plan=>({...plan,counselor_id:profile.id}))].map(plan=>[plan.id,plan])).values()]
    .sort((a,b)=>b.week_start.localeCompare(a.week_start)||a.id.localeCompare(b.id));
  const completedItemIds = [...new Set((completedRows as Array<{item_id:string}>).map(row => row.item_id))].sort();

  return (
    <DashboardShell role="counselor" name={profile.full_name}>
      <section className="portal-heading">
        <div>
          <h1>برنامه‌ریزی هفتگی</h1>
        </div>
      </section>

      {params.selected && (
        <div className="portal-alert success">
          دانش‌آموز به فهرست مشاوره تو اضافه شد.
        </div>
      )}
      {params.saved && (
        <div className="portal-alert success">
          {params.saved === "published"
            ? "برنامه منتشر شد و دانش‌آموز می‌تواند آن را ببیند."
            : "پیش‌نویس برنامه ذخیره شد."}
        </div>
      )}
      {params.error && (
        <div className="portal-alert error">
          {params.error === "overlap" ? "این بازه با روزهای دارای فعالیتِ برنامهٔ دیگری هم‌پوشانی دارد." : params.error === "week" ? "برای برنامهٔ جدید، امروز یا یک روز آینده را انتخاب کن؛ برنامهٔ تمام‌شده قابل تغییر نیست." : params.error === "protected" ? "باکس انجام‌شده قابل تغییر یا حذف نیست. ممکن است دانش‌آموز پس از باز شدن فرم آن را انجام داده باشد؛ صفحه را تازه‌سازی کن و بقیهٔ فعالیت‌ها را ویرایش کن." : params.error === "exam-identity" ? "باکس‌های آزمون هم‌نام قابل تشخیص نیستند؛ برای جلوگیری از اتصال آزمون به باکس اشتباه، ذخیره انجام نشد. برنامه را تازه‌سازی و باکس‌های آزمون را بررسی کن." : params.error === "routines" ? "روتین هر هفت روز باید کامل و یکتا باشد و درس روتین باید مربوط به رشتهٔ دانش‌آموز باشد." : "ذخیره انجام نشد. اطلاعات برنامه را بررسی و دوباره تلاش کن."}
        </div>
      )}

      <WeeklyPlanBuilder
        key={[params.student, params.progress_student, params.plan, params.week_start, params.error, params.saved, ...completedItemIds].join(":")}
        students={selectedStudents}
        plans={counselorPlans}
        numberingPlans={recentPlans}
        overlapPlans={recentPlans}
        recentPlans={recentPlans}
        counselorId={profile.id}
        counselorName={profile.full_name}
        privateDrafts={capability.data}
        initialStudentId={params.student ?? params.progress_student}
        initialPlanId={params.plan}
        initialWeekStart={params.week_start}
        initialSaved={params.saved}
        completedItemIds={completedItemIds}
      />
    </DashboardShell>
  );
}
