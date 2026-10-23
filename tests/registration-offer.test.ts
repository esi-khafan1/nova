import assert from "node:assert/strict";
import React from "react";
import {renderToStaticMarkup} from "react-dom/server";
require.extensions['.css']=()=>{};
const {CoursePrice}=require('../components/registration/course-price');
for(const [grade,course,percentage] of [[11,'progress','۳۰'],[12,'base','۲۸'],[12,'progress','۲۶'],[10,'base','۳۰']] as const){
 const html=renderToStaticMarkup(React.createElement(CoursePrice,{selection:{grade,field:'humanities',course,months:1},offer:true}));
 assert.ok(html.includes(`${percentage}٪ تخفیف برای شروع مسیرت`));assert.ok(html.includes('مبلغ قابل پرداخت'));assert.ok(html.includes('<del>'));
}
console.log('Registration offer: original strikeout, separate payable label and rounded promotional percentages passed.');
