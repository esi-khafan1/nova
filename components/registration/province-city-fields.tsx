"use client";
import { useId, useState } from "react";
import { provinces, type RegistrationFormValues } from "@/lib/registration";
import { citiesForProvince } from "@/lib/iran-cities";
const OTHER_CITY = "__other_city__";
export function ProvinceCityFields({ values }: { values: RegistrationFormValues }) {
  const descriptionId = useId();
  const initialProvince = provinces.includes(values.province ?? "") ? values.province ?? "" : "";
  const initialCity = values.city?.trim() ?? "";
  const [province, setProvince] = useState(initialProvince);
  const [selectedCity, setSelectedCity] = useState(initialCity && initialProvince ? citiesForProvince(initialProvince).includes(initialCity) ? initialCity : OTHER_CITY : "");
  const [customCity, setCustomCity] = useState(initialCity);
  const cities = citiesForProvince(province);
  const other = selectedCity === OTHER_CITY;
  function changeProvince(value: string) {
    setProvince(value);
    setSelectedCity("");
    setCustomCity("");
  }
  return <>
    <label>استان<select name="province" autoComplete="address-level1" required value={province} onChange={event => changeProvince(event.target.value)}><option value="" disabled>انتخاب استان</option>{provinces.map(p => <option key={p} value={p}>{p}</option>)}</select></label>
    <label>شهر محل سکونت<select name={other ? undefined : "city"} autoComplete="address-level2" aria-label="شهر محل سکونت" required value={selectedCity} disabled={!province} aria-describedby={descriptionId} onChange={event => setSelectedCity(event.target.value)}><option value="" disabled>{province ? "انتخاب شهر" : "ابتدا استان را انتخاب کن"}</option>{cities.map(city => <option value={city} key={city}>{city}</option>)}{province && <option value={OTHER_CITY}>شهر من در فهرست نیست</option>}</select><small id={descriptionId}>{province ? `شهرهای استان ${province}` : "پس از انتخاب استان، فهرست شهرهای آن نمایش داده می‌شود."}</small></label>
    {other && <label>نام شهر<input name="city" autoComplete="address-level2" required minLength={2} maxLength={60} value={customCity} onChange={event => setCustomCity(event.target.value)} placeholder="نام شهر محل سکونت"/></label>}
  </>;
}
