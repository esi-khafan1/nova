import type { createClient } from "./supabase/server";
import type { RegistrationRow } from "./registration";
export async function loadRegistrationDirectory(supabase:Awaited<ReturnType<typeof createClient>>){
 const rows:RegistrationRow[]=[];
 for(let offset=0;;offset+=500){const {data,error}=await supabase.rpc("registration_directory").range(offset,offset+499);if(error)throw new Error("Registration directory unavailable");rows.push(...(data??[]) as RegistrationRow[]);if(!data||data.length<500)break;}
 return rows;
}
