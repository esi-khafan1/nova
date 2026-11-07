export type CourseOffer = {grade: 9|10|11|12; plan: "base"|"progress"; discount_percent: number; monthly_price: number; reservation: boolean};
export type CourseOffers = CourseOffer[];

export function originalMonthlyPrice(grade: number, plan: "base"|"progress") {
  return grade === 12 ? (plan === "base" ? 3200000 : 3500000) : (plan === "base" ? 3000000 : 3400000);
}
export function priceFromDiscount(grade: number, plan: "base"|"progress", percent: number) {
  return Math.round(originalMonthlyPrice(grade,plan)*(100-percent)/100/10000)*10000;
}
// The explicitly chosen initial prices override rounding of the percentage.
export const defaultCourseOffers: CourseOffers = ([9,10,11,12] as const).flatMap(grade => (["base","progress"] as const).map(plan => ({
  grade,plan,discount_percent:grade===12?15:17,
  monthly_price:grade===12?(plan==="base"?2700000:3000000):(plan==="base"?2490000:2790000),reservation:false,
})));
export function findCourseOffer(offers: CourseOffers, grade: number, plan: string) {
  return offers.find(offer=>offer.grade===grade && offer.plan===plan);
}
