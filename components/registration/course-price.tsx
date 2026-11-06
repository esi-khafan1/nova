import {coursePrice,type CourseSelection} from "@/lib/courses";
import "./course-price.css";
export function CoursePrice({selection,offer=false}:{selection:CourseSelection;offer?:boolean}) {
 const price=coursePrice(selection);
 if(price===null)return null;
 const money=price.toLocaleString("fa-IR");
 return <div className="course-price" aria-label={`قیمت ${money} تومان`}>
  {offer&&<span>مبلغ قابل پرداخت</span>}
  <strong>{money} <span>تومان</span></strong>
 </div>;
}
