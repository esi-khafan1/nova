import { cache } from "react";
import { createClient } from "@/lib/supabase/server";
import type { CourseOffer, CourseOffers } from "@/lib/course-offers";

export const loadCourseOffers = cache(async (): Promise<CourseOffers | null> => {
  try {
    const supabase = await createClient();
    const {data,error} = await supabase.rpc("get_course_offer_settings_v2");
    if (error || !Array.isArray(data) || data.length !== 8) return null;
    const offers = data as CourseOffer[];
    if (!offers.every(o=>[9,10,11,12].includes(o.grade) && ["base","progress"].includes(o.plan) && Number.isInteger(o.monthly_price) && o.monthly_price>=0 && Number.isInteger(o.discount_percent) && o.discount_percent>=0 && o.discount_percent<=100 && typeof o.reservation==="boolean" && typeof o.sold_out==="boolean" && !(o.reservation && o.sold_out))) return null;
    if (new Set(offers.map(o=>`${o.grade}-${o.plan}`)).size!==8 || offers.some(o=>o.reservation!==offers[0].reservation || o.sold_out!==offers[0].sold_out)) return null;
    return offers;
  } catch { return null; }
});
