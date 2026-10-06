import {
  persianParts,
  samePersianMonth,
  toIsoDate,
} from "@/lib/persian-date";

export type ProgressSourceItem = {
  id: string;
  planId: string;
  plannedDate: Date;
  durationMinutes: number;
  subject: string;
  chapter: string | null;
  activityType: string;
  targetTestCount: number | null;
};

export type ProgressChapter = {
  chapter: string;
  plannedMinutes: number;
  completedMinutes: number;
  studyMinutes: number;
  testMinutes: number;
  targetTests: number;
  completedTests: number;
  monthlyMinutes: number[];
  monthlyTests: number[];
};

export type ProgressScope = {
  key: "daily" | "weekly" | "monthly" | "all";
  label: string;
  completedCount: number;
  totalMinutes: number;
  studyMinutes: number;
  testMinutes: number;
  targetTests: number;
  completedTests: number;
  subjects: { subject: string; chapters: ProgressChapter[] }[];
};

const studyActivities = new Set([
  "lesson",
  "notes",
  "review",
  "homework",
  "summary",
  "class",
  "other",
]);

function buildScope(
  key: ProgressScope["key"],
  label: string,
  items: ProgressSourceItem[],
  completedIds: Set<string>,
  completedTestCounts: Map<string, number>,
): ProgressScope {
  const subjects = new Map<string, Map<string, ProgressChapter>>();
  let completedCount = 0;
  let totalMinutes = 0;
  let studyMinutes = 0;
  let testMinutes = 0;
  let targetTests = 0;
  let completedTests = 0;

  for (const item of items) {
    const chapterName = item.chapter?.trim() || "مبحث آزاد";
    const chapters = subjects.get(item.subject) ?? new Map();
    const chapter = chapters.get(chapterName) ?? {
      chapter: chapterName,
      plannedMinutes: 0,
      completedMinutes: 0,
      studyMinutes: 0,
      testMinutes: 0,
      targetTests: 0,
      completedTests: 0,
      monthlyMinutes: [0, 0, 0, 0, 0],
      monthlyTests: [0, 0, 0, 0, 0],
    };

    chapter.plannedMinutes += item.durationMinutes;
    if (item.activityType === "practice_tests") {
      chapter.targetTests += item.targetTestCount ?? 0;
      targetTests += item.targetTestCount ?? 0;
    }

    if (completedIds.has(item.id)) {
      completedCount += 1;
      totalMinutes += item.durationMinutes;
      chapter.completedMinutes += item.durationMinutes;
      if (studyActivities.has(item.activityType)) {
        studyMinutes += item.durationMinutes;
        chapter.studyMinutes += item.durationMinutes;
      } else {
        testMinutes += item.durationMinutes;
        chapter.testMinutes += item.durationMinutes;
      }

      const tests = completedTestCounts.get(item.id) ?? 0;
      chapter.completedTests += tests;
      completedTests += tests;

      if (key === "monthly") {
        const weekIndex = Math.min(
          4,
          Math.floor((persianParts(item.plannedDate).day - 1) / 7),
        );
        chapter.monthlyMinutes[weekIndex] += item.durationMinutes;
        chapter.monthlyTests[weekIndex] += tests;
      }
    }

    chapters.set(chapterName, chapter);
    subjects.set(item.subject, chapters);
  }

  return {
    key,
    label,
    completedCount,
    totalMinutes,
    studyMinutes,
    testMinutes,
    targetTests,
    completedTests,
    subjects: [...subjects.entries()]
      .map(([subject, chapters]) => ({
        subject,
        chapters: [...chapters.values()].sort(
          (first, second) =>
            second.completedMinutes - first.completedMinutes ||
            second.plannedMinutes - first.plannedMinutes,
        ),
      }))
      .sort(
        (first, second) =>
          second.chapters.reduce(
            (sum, chapter) => sum + chapter.plannedMinutes,
            0,
          ) -
          first.chapters.reduce(
            (sum, chapter) => sum + chapter.plannedMinutes,
            0,
          ),
      ),
  };
}

export function buildProgressScopes({
  items,
  currentPlanId,
  completedIds,
  completedTestCounts,
  now = new Date(),
  includeDaily = false,
}: {
  items: ProgressSourceItem[];
  currentPlanId: string | null;
  completedIds: Set<string>;
  completedTestCounts: Map<string, number>;
  now?: Date;
  includeDaily?: boolean;
}): ProgressScope[] {
  const todayIso = toIsoDate(now);
  const dailyItems = items.filter(
    (item) => toIsoDate(item.plannedDate) === todayIso,
  );
  const weeklyItems = items.filter((item) => item.planId === currentPlanId);
  const monthlyItems = items.filter((item) =>
    samePersianMonth(item.plannedDate, now),
  );

  const scopes: ProgressScope[] = [
    buildScope(
      "weekly",
      "هفتگی",
      weeklyItems,
      completedIds,
      completedTestCounts,
    ),
    buildScope(
      "monthly",
      "ماهانه",
      monthlyItems,
      completedIds,
      completedTestCounts,
    ),
    buildScope("all", "کلی", items, completedIds, completedTestCounts),
  ];

  return includeDaily
    ? [
        buildScope(
          "daily",
          "امروز",
          dailyItems,
          completedIds,
          completedTestCounts,
        ),
        ...scopes,
      ]
    : scopes;
}
