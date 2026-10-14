import { createClient } from "@supabase/supabase-js";
import { exportTokenHash,parseExportToken,formatSheetSnapshot } from "@/lib/google-sheet-export";
export const dynamic="force-dynamic";
const headers={"Cache-Control":"private, no-store","X-Content-Type-Options":"nosniff"};
export async function GET(request:Request){
 const token=parseExportToken(request.headers.get("authorization"));if(!token)return Response.json({error:"Unauthorized"},{status:401,headers});
 const url=process.env.NEXT_PUBLIC_SUPABASE_URL,key=process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY??process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
 if(!url||!key)return Response.json({error:"Export unavailable"},{status:503,headers});
 const supabase=createClient(url,key,{auth:{persistSession:false,autoRefreshToken:false,detectSessionInUrl:false}});
 try{const {data,error}=await supabase.rpc("sheet_export_snapshot",{hash_value:await exportTokenHash(token)});
 if(error||!data)return Response.json({error:error?.code==="28000"?"Unauthorized":"Export unavailable"},{status:error?.code==="28000"?401:503,headers});
 return Response.json(formatSheetSnapshot(data),{headers});
 }catch{return Response.json({error:"Export unavailable"},{status:503,headers});}
}
