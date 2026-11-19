import { createClient } from '@/lib/supabase/server';

export const dynamic = 'force-dynamic';

// Explicitly limited to planner operations already authorized by their RPCs.
// Never accept an upstream URL, API key, token, or arbitrary database function.
const operations = new Set([
  'counselor_plan_editor_page', 'counselor_completed_plan_item_ids',
  'planner_get_published_extras', 'planner_get_working_draft',
  'planner_save_working_draft_checked', 'planner_discard_working_draft', 'planner_publish_working_draft',
  'planner_review_week', 'planner_set_historical_review_completed', 'planner_set_review_completed',
  'planner_list_presets', 'planner_save_preset', 'planner_delete_preset',
  'planner_list_topics', 'planner_topic_history', 'planner_list_topic_chapters',
]);
const maxBytes = 6 * 1024 * 1024;
const response = (body: unknown, status = 200) => Response.json(body, {status, headers: {'Cache-Control': 'no-store'}});

async function readBody(request: Request): Promise<unknown> {
  if (!request.body) throw new Error('Missing body');
  const reader = request.body.getReader();
  const chunks: Uint8Array[] = [];
  let size = 0;
  while (true) {
    const {done, value} = await reader.read();
    if (done) break;
    size += value.byteLength;
    if (size > maxBytes) { await reader.cancel(); throw new Error('Body too large'); }
    chunks.push(value);
  }
  const bytes = new Uint8Array(size);
  let offset = 0;
  for (const chunk of chunks) { bytes.set(chunk, offset); offset += chunk.byteLength; }
  return JSON.parse(new TextDecoder().decode(bytes));
}

export async function POST(request: Request) {
  // Cookie-authenticated mutations must originate from this site, not a form
  // or a cross-origin fetch. Do not enable CORS for this endpoint.
  const origin = request.headers.get('origin');
  const host = request.headers.get('host');
  const protocol = request.headers.get('x-forwarded-proto')?.split(',')[0].trim() ?? new URL(request.url).protocol.slice(0, -1);
  let sameOrigin = false;
  try {
    const parsed = new URL(origin ?? '');
    sameOrigin = (protocol === 'https' || protocol === 'http') && parsed.protocol === `${protocol}:` && parsed.host === host && parsed.origin === origin;
  } catch { /* Reject missing or malformed origins. */ }
  if (!sameOrigin || request.headers.get('sec-fetch-site') === 'cross-site') return response({error:'Forbidden'}, 403);
  if (request.headers.get('content-type')?.split(';')[0].trim().toLowerCase() !== 'application/json') return response({error:'Unsupported content type'}, 415);
  let input: unknown;
  try { input = await readBody(request); } catch { return response({error:'Invalid request'}, 400); }
  if (!input || typeof input !== 'object' || Array.isArray(input) || !('name' in input) || typeof input.name !== 'string') return response({error:'Invalid request'}, 400);
  const name = input.name;
  if (name !== 'current_user' && !operations.has(name)) return response({error:'Unknown operation'}, 400);
  const args = 'args' in input ? input.args : {};
  if (!args || typeof args !== 'object' || Array.isArray(args)) return response({error:'Invalid arguments'}, 400);
  try {
    const supabase = await createClient();
    const {data: {user}, error: authError} = await supabase.auth.getUser();
    if (authError || !user) return response({data:null, error:{code:'UNAUTHENTICATED', message:'Authentication required'}}, 401);
    if (name === 'current_user') return response({data:{id:user.id}, error:null});
    const {data, error} = await supabase.rpc(name, args);
    // Do not expose internal details, but retain the database code used by
    // conflict and data-protection handling in the planner.
    return response({data: error ? null : data, error: error ? {code:error.code, message:'Planner operation failed'} : null});
  } catch {
    return response({data:null, error:{code:'PLANNER_CONNECTION', message:'Planner request failed'}}, 503);
  }
}
