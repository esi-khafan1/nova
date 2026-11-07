import {coursePrice,type CourseSelection} from "@/lib/courses";
import {defaultCourseOffers,findCourseOffer,type CourseOffers} from "@/lib/course-offers";
import "./course-price.css";
export function CoursePrice({selection,offer=false,offers=defaultCourseOffers}:{selection:CourseSelection;offer?:boolean;offers?:CourseOffers}) {
 const price=coursePrice(selection,offers);
 if(price===null)return null;
 const discount=findCourseOffer(offers,selection.grade,selection.course)?.discount_percent ?? 0;
 const money=price.toLocaleString("fa-IR");
 return <div className="course-price" aria-label={`قیمت ${money} تومان${discount>0 ? `، ${discount.toLocaleString("fa-IR")} درصد تخفیف` : ""}`}>
  {discount>0&&<span>{discount.toLocaleString("fa-IR")}٪ تخفیف</span>}
  {offer&&<span>مبلغ قابل پرداخت</span>}
  <strong>{money} <span>تومان</span></strong>
 </div>;
}
