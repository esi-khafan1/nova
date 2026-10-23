import {coursePrice,type CourseSelection} from "@/lib/courses";
import "./course-price.css";
export function CoursePrice({selection}:{selection:CourseSelection}) {
 const price=coursePrice(selection);
 if(!price)return null;
 const money=(n:number)=>n.toLocaleString("fa-IR");
 return <div className="course-price" aria-label={`قیمت قبلی ${money(price.original)} تومان؛ قیمت با تخفیف ${money(price.discounted)} تومان`}>
  <del>{money(price.original)}</del>
  <strong>{money(price.discounted)} <span>تومان</span></strong>
 </div>;
}
