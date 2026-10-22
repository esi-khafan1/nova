import {headers} from "next/headers";
import {getPerformanceTrace} from "@/lib/performance/trace";
import {PerformanceReport} from "./performance-report";
export async function ServerPerformanceReport({route}:{route:string}) {
 const h=await headers();
 const claims=Number(h.get("x-nova-perf-claims-ms"));
 const start=Number(h.get("x-nova-perf-start-ms"));
 const stages=[...getPerformanceTrace().stages];
 if(h.has("x-nova-perf-claims-ms")&&Number.isFinite(claims))stages.unshift({stage:"middleware_claims",ms:claims});
 const readyMs=start>0&&Number.isFinite(start)?Math.max(0,Date.now()-start):null;
 return <PerformanceReport route={route} stages={stages} readyMs={readyMs}/>;
}
