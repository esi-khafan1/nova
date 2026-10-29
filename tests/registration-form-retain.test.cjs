const test = require('node:test');
const assert = require('node:assert/strict');
const { readFileSync } = require('node:fs');
const vm = require('node:vm');
const ts = require('typescript');

const source = readFileSync('components/registration/registration-form.tsx', 'utf8');
const compiled = ts.transpileModule(source, {
  fileName: 'registration-form.tsx',
  compilerOptions: { jsx: ts.JsxEmit.ReactJSX, module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2022 },
}).outputText;

for (const mode of ['profile', 'enrollment']) {
  test(`${mode} validation errors leave the student's typed fields and receipt intact`, () => {
    let transitions = 0;
    const dispatched = [];
    const moduleStub = { exports: {} };
    class FormDataSnapshot {
      constructor(form) {
        this.fields = { ...form.fields };
        this.receipt = form.receipt;
      }
    }
    const jsx = (type, props) => ({ type, props });
    const deps = {
      react: {
        useActionState: () => [{ error: 'فیلد نامعتبر است.' }, fd => dispatched.push(fd), false],
        startTransition: callback => { transitions++; callback(); },
      },
      'react/jsx-runtime': { jsx, jsxs: jsx },
      './course-price': { CoursePrice: () => null },
      '@/app/dashboard/registration/actions': { submitRegistration: () => ({ error: 'فیلد نامعتبر است.' }) },
      '@/lib/courses': { courseTypeLabel: () => '', courseDurationLabel: () => '' },
      '@/lib/study-catalog': { studyFieldLabels: {} },
      '@/components/registration/province-city-fields': { ProvinceCityFields: () => null },
    };
    vm.runInNewContext(compiled, {
      module: moduleStub, exports: moduleStub.exports, FormData: FormDataSnapshot,
      require(name) { if (!(name in deps)) throw Error(name); return deps[name]; },
    });
    const form = moduleStub.exports.RegistrationForm({ values: { full_name: 'نام واردشده' }, mode });
    assert.equal(form.type, 'form');
    assert.equal(typeof form.props.action, 'function', 'Keep native form-action fallback without JavaScript.');
    assert.equal(typeof form.props.onSubmit, 'function');
    const currentTarget = { fields: { full_name: 'نام واردشده', phone: 'شمارهٔ نامعتبر', city: 'تهران' }, receipt: { name: 'receipt.png' } };
    let prevented = false;
    form.props.onSubmit({ currentTarget, preventDefault() { prevented = true; } });
    assert.equal(prevented, true, 'Prevent React form-action reset on server validation errors.');
    assert.equal(transitions, 1, 'Dispatch the server action in a transition for pending state.');
    assert.equal(dispatched.length, 1);
    assert.equal(dispatched[0].fields.phone, 'شمارهٔ نامعتبر');
    assert.equal(dispatched[0].receipt, currentTarget.receipt);
    assert.equal(currentTarget.fields.full_name, 'نام واردشده');
    assert.equal(currentTarget.receipt.name, 'receipt.png');
  });
}
