import type { NextRequest } from "next/server";
import { AUTH_SITE_ORIGIN } from "@/lib/auth-urls";

/** Trust configured public origins, not proxy-internal URLs or forwarded headers. */
export function isTrustedAuthOrigin(request: Pick<NextRequest,"headers"|"nextUrl">): boolean {
 const raw=request.headers.get("origin");
 if(!raw||request.headers.get("sec-fetch-site")==="cross-site")return false;
 try{
  const origin=new URL(raw);
  if(!["http:","https:"].includes(origin.protocol)||origin.username||origin.password||origin.pathname!=="/"||origin.search||origin.hash)return false;
  const configured=[AUTH_SITE_ORIGIN,...(process.env.AUTH_ALLOWED_ORIGINS??"").split(",")];
  for(const value of configured){
   try{const trusted=new URL(value.trim());if(trusted.protocol==="https:"&&origin.origin===trusted.origin)return true;}catch{}
  }
  // Local development only. Production never trusts arbitrary Host/X-Forwarded-Host.
  return process.env.NODE_ENV!=="production"&&origin.origin===request.nextUrl.origin;
 }catch{return false;}
}
