// Student account state transitions. Auth failures remain in needs_review.
const UUID = /^[0-9a-f]{8}-(?:[0-9a-f]{4}-){3}[0-9a-f]{12}$/i;
const response = (status, body) => new Response(JSON.stringify(body), {
  status, headers: { 'content-type': 'application/json', 'cache-control': 'no-store' },
});

// begin validates the caller inside the database, locks the target profile,
// prevents role changes, records the operation, and denies service immediately.
// finish is service-only and never releases a block on an uncertain failure.
export function makeStudentAccountBlockHandler({ verifyUser, begin, setAuthBan, finish, randomUUID }) {
  return async (request) => {
    if (request.method !== 'POST') return response(405, { error: 'method' });
    const authorization = request.headers.get('authorization') || '';
    if (!/^Bearer \S+$/i.test(authorization)) return response(401, { error: 'unauthorized' });
    let body;
    try {
      const reader = request.body?.getReader();
      if (!reader) return response(400, { error: 'invalid' });
      const chunks = []; let length = 0;
      for (;;) {
        const item = await reader.read();
        if (item.done) break;
        length += item.value.byteLength;
        if (length > 2048) { await reader.cancel(); return response(413, { error: 'invalid' }); }
        chunks.push(item.value);
      }
      const data = new Uint8Array(length); let offset = 0;
      for (const chunk of chunks) { data.set(chunk, offset); offset += chunk.byteLength; }
      body = JSON.parse(new TextDecoder().decode(data));
    } catch { return response(400, { error: 'invalid' }); }
    if (!body || typeof body !== 'object' || Array.isArray(body) ||
        typeof body.target_id !== 'string' || !UUID.test(body.target_id) ||
        typeof body.blocked !== 'boolean') return response(400, { error: 'invalid' });
    try {
      const user = await verifyUser(authorization);
      if (!user?.id) return response(401, { error: 'unauthorized' });
      const operation = randomUUID();
      if (!UUID.test(operation)) throw new Error('Invalid operation identifier');
      // The DB must derive the actor from the verified JWT, not body/user.id.
      const started = await begin(authorization, body.target_id, body.blocked, operation);
      if (!started) return response(409, { error: 'not_started' });
      let succeeded = false;
      let authUntil = null;
      try {
        // The adapter uses the Auth Admin API, never direct auth.users edits.
        authUntil = await setAuthBan(body.target_id, body.blocked, started.auth_banned_until);
        succeeded = true;
      } catch {
        // Network failure can be ambiguous. Keep the account fail-closed.
      }
      try { await finish(operation, succeeded, authUntil ?? null); }
      catch { return response(503, { error: 'uncertain' }); }
      if (!succeeded) return response(503, { error: 'uncertain' });
      return response(200, { ok: true });
    } catch { return response(503, { error: 'unavailable' }); }
  };
}

// Only lift the exact Auth ban created by this flow, not a ban from another
// operator. Errors never release the database guard.
export function makeAuthBanSetter(admin) {
  return async (target, blocked, expected) => {
    const {data, error} = await admin.auth.admin.getUserById(target);
    if (error || !data.user) throw new Error("Auth account unavailable");
    const current = data.user.banned_until;
    if (blocked) {
      if (current && Date.parse(current) > Date.now()) throw new Error("Already banned independently");
    } else if (!expected || !current || Date.parse(current) !== Date.parse(expected)) {
      throw new Error("Auth ban no longer matches");
    }
    const result = await admin.auth.admin.updateUserById(target, {ban_duration: blocked ? "876000h" : "none"});
    if (result.error || !result.data.user) throw new Error("Auth update not confirmed");
    if (blocked && (!result.data.user.banned_until || Date.parse(result.data.user.banned_until) <= Date.now())) throw new Error("Auth ban not confirmed");
    if (!blocked && result.data.user.banned_until && Date.parse(result.data.user.banned_until) > Date.now()) throw new Error("Auth unban not confirmed");
    return blocked ? result.data.user.banned_until ?? null : null;
  };
}
