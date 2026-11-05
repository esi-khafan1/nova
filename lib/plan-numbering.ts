// Sequence is per student, from the earliest week. Include own drafts and
// published plans from a previous counselor; never count another student.
export type NumberablePlan = { id: string; student_id: string; week_start: string };
export function planNumbers(plans: NumberablePlan[]): Map<string, number> {
  const numbers = new Map<string, number>();
  const counts = new Map<string, number>();
  const distinct = [...new Map(plans.map(plan => [plan.id, plan])).values()];
  distinct.sort((a, b) => a.week_start.localeCompare(b.week_start) || a.id.localeCompare(b.id));
  for (const plan of distinct) {
    const next = (counts.get(plan.student_id) ?? 0) + 1;
    counts.set(plan.student_id, next);
    numbers.set(plan.id, next);
  }
  return numbers;
}
export function nextPlanNumber(plans: NumberablePlan[], studentId: string, weekStart: string): number {
  return plans.filter(p => p.student_id === studentId && p.week_start <= weekStart).length + 1;
}
export function numberedPlanTitle(title: string, number: number): string {
  return `برنامهٔ ${number.toLocaleString('fa-IR')}${title.trim() && title.trim() !== 'برنامه هفتگی' ? ` · ${title}` : ''}`;
}
