"use client";
import {useState} from "react";
import {saveCourseOffer} from "@/app/dashboard/admin/courses/actions";
import {originalMonthlyPrice,priceFromDiscount,type CourseOffer} from "@/lib/course-offers";

export function CourseOfferForm({offer}:{offer:CourseOffer}) {
  const [discount,setDiscount]=useState(String(offer.discount_percent));
  const [price,setPrice]=useState(String(offer.monthly_price));
  function changeDiscount(value:string) {
    setDiscount(value);
    if (/^\d{1,3}$/.test(value) && Number(value)<=100) setPrice(String(priceFromDiscount(offer.grade,offer.plan,Number(value))));
  }
  return <form action={saveCourseOffer} className="course-settings-offer">
    <input type="hidden" name="grade" value={offer.grade}/><input type="hidden" name="plan" value={offer.plan}/>
    <strong>{offer.plan==="base"?"پلن پایه":"پلن پریمیوم"}</strong>
    <small>قیمت اصلی ماهانه: {originalMonthlyPrice(offer.grade,offer.plan).toLocaleString("fa-IR")} تومان</small>
    <div className="course-settings-fields">
      <label>تخفیف (درصد)<input name="discount" type="number" min="0" max="100" step="1" required value={discount} onChange={e=>changeDiscount(e.target.value)}/></label>
      <label>قیمت ماهانه (تومان)<input name="price" type="number" min="0" max="100000000" step="10000" required value={price} onChange={e=>setPrice(e.target.value)}/></label>
      <button className="button button-small" type="submit">ثبت</button>
    </div>
  </form>;
}
