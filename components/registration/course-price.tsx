import {coursePrice,type CourseSelection} from "@/lib/courses";
import "./course-price.css";
export function CoursePrice({selection,offer=false}:{selection:CourseSelection;offer?:boolean}) {
 const price=coursePrice(selection);
 if(!price)return null;
 const money=(n:number)=>n.toLocaleString("fa-IR");
 return <div className="course-price" aria-label={`قیمت قبلی ${money(price.original)} تومان؛ قیمت با تخفیف ${money(price.discounted)} تومان`}>
  <del>{money(price.original)}</del>
  {offer&&<span className="course-offer-tag">{money(Math.round((1-price.discounted/price.original)*100))}٪ تخفیف برای شروع مسیرت</span>}
  {offer&&<span>مبلغ قابل پرداخت</span>}
  <strong>{money(price.discounted)} <span>تومان</span></strong>
 </div>;
}
