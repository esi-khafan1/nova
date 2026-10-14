import assert from 'node:assert/strict';
import {readFileSync} from 'node:fs';
const ui=readFileSync('components/auth/unified-auth.tsx','utf8');
const css=readFileSync('app/auth/auth-gradient.css','utf8');
const route=readFileSync('app/auth/page.tsx','utf8');
assert.match(ui,/import \{ LandingHeader \} from "@\/components\/landing-header"/);
assert.equal((ui.match(/<LandingHeader /g)||[]).length,1);
assert.doesNotMatch(ui,/<Logo\b|comet-star|auth-gradient-header/);
assert.match(route,/import "\.\.\/landing-approved\.css"/);
assert.doesNotMatch(css,/\.nova-site-header\s*\{|\.nova-header-(inner|brand|tools)\s*\{/);
assert.match(ui,/safeReturnPath\(returnTo\)/);
assert.match(ui,/emailRedirectTo: emailConfirmationUrl\(destination\)/);
assert.match(ui,/router\.push\(destination\)/);
assert.match(ui,/autoComplete=\{mode === "signin" \? "current-password" : "new-password"\}/);
assert.match(ui,/aria-controls="auth-form-panel"/);
assert.match(ui,/"ArrowLeft", "ArrowRight", "Home", "End"/);
assert.match(css,/prefers-reduced-motion/);
assert.doesNotMatch(ui,/nova-auth-art|\/nova\/hero\.svg|next\/image/);
assert.match(css,/grid-template-areas: "story form"/);
assert.match(css,/\.nova-auth-story \{ display: none; \}/);
assert.doesNotMatch(css,/overflow-y:\s*(hidden|clip)|(?:^|[;{])\s*height:\s*100(?:s|d)?vh;/m);
console.log('Compact, image-free auth UI reuses the exact landing navbar, removes the old logo, scopes styles and preserves confirmation/return-path wiring.');

assert.match(ui, /<Link href="\/">بازگشت به خانه <AuthIcon name="arrow" \/><\/Link>/);
assert.match(css, /\.nova-auth-topline > a \{[^}]*min-height: 44px/);

assert.match(ui, /nova-auth-topline-caption/);
assert.match(ui, /یک شروع روشن، /);
assert.match(css, /\.nova-auth-topline \{[^}]*justify-content: space-between/);
