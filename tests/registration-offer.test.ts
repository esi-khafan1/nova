import assert from "node:assert/strict";
import React from "react";
import {renderToStaticMarkup} from "react-dom/server";
require.extensions['.css']=()=>{};
const {CoursePrice}=require('../components/registration/course-price');
for(const [grade,course,amount] of [[9,'base','۲٬۴۹۰٬۰۰۰'],[10,'base','۲٬۴۹۰٬۰۰۰'],[11,'progress','۲٬۷۹۰٬۰۰۰'],[12,'base','۲٬۷۰۰٬۰۰۰'],[12,'progress','۳٬۰۰۰٬۰۰۰']] as const){
 for(const offer of [false,true]) {
  const html=renderToStaticMarkup(React.createElement(CoursePrice,{selection:{grade,field:grade===9?null:'humanities',course,months:1},offer}));
  assert.ok(html.includes(amount));
  assert.equal(html.includes('مبلغ قابل پرداخت'),offer);
  assert.ok(!html.includes('<del>'));
  assert.ok(html.includes('تخفیف'));
 }
}
console.log('Course prices display the payable amount with their discount.');
