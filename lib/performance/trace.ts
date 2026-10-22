import { cache } from "react";
export type Timing = { stage: string; ms: number };
// React request scope only: never share timings across requests or users.
export const getPerformanceTrace = cache(() => ({ stages: [] as Timing[] }));
export function recordPerformance(stage: string, started: number) {
 getPerformanceTrace().stages.push({stage,ms:Math.max(0,Math.round(performance.now()-started))});
}
export async function measurePerformance<T>(stage:string,work:()=>PromiseLike<T>):Promise<T> {
 const started=performance.now();
 try{return await work();}finally{recordPerformance(stage,started);}
}
