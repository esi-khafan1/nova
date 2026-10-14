export const dynamic="force-dynamic";
export async function GET(){return Response.json({error:"External Sheets integration has been retired"},{status:410,headers:{"Cache-Control":"private, no-store","X-Content-Type-Options":"nosniff"}});}
