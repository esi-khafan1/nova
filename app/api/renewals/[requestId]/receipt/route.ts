import {requireProfile} from '@/lib/auth';
import {NextResponse} from 'next/server';
export async function GET(_request:Request,{params}:{params:Promise<{requestId:string}>}){
 const {supabase}=await requireProfile(['admin','student'],true);const {requestId}=await params;
 if(!/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(requestId))return new NextResponse('Not found',{status:404});
 const {data,error}=await supabase.rpc('student_renewal_receipt',{target_request_id:requestId});
 if(error||typeof data!=='string')return new NextResponse('Not found',{status:404,headers:{'Cache-Control':'private, no-store'}});
 const {data:signed,error:signError}=await supabase.storage.from('registration-receipts').createSignedUrl(data,60);
 if(signError||!signed)return new NextResponse('Receipt unavailable',{status:503,headers:{'Cache-Control':'private, no-store'}});
 return new NextResponse(null,{status:307,headers:{Location:signed.signedUrl,'Cache-Control':'private, no-store','Referrer-Policy':'no-referrer'}});
}
