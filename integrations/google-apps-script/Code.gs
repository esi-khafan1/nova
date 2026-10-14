/* Nova private Sheets connector. Bind this script ONLY to the private ADMIN spreadsheet.
 * Never share the admin spreadsheet/script or put credentials in spreadsheet cells.
 * Counselor spreadsheets are separate files, shared as Viewer only, manually by the admin.
 */
const NOVA_ENDPOINT = 'https://nova-academy.ir/api/integrations/google-sheets';
const NOVA_DATA_TAB = 'دانش‌آموزها';
const NOVA_STATUS_TAB = 'وضعیت اتصال';
const NOVA_TARGETS_KEY = 'NOVA_TARGETS';

function onOpen() {
  SpreadsheetApp.getUi().createMenu('نووا')
    .addItem('اتصال شیت ادمین', 'connectNovaAdmin')
    .addItem('به‌روزرسانی اکنون', 'syncNovaNow')
    .addItem('فعال‌کردن به‌روزرسانی ساعتی', 'installNovaHourlySync')
    .addItem('تعویض کلید اتصال', 'replaceNovaKey')
    .addToUi();
}

function novaPrompt_(title, message) {
  const ui = SpreadsheetApp.getUi();
  const result = ui.prompt(title, message, ui.ButtonSet.OK_CANCEL);
  return result.getSelectedButton() === ui.Button.OK ? result.getResponseText().trim() : null;
}
function novaProperties_() { return PropertiesService.getScriptProperties(); }
function novaTargets_() { return JSON.parse(novaProperties_().getProperty(NOVA_TARGETS_KEY) || '[]'); }
function novaSaveTargets_(targets) { novaProperties_().setProperty(NOVA_TARGETS_KEY, JSON.stringify(targets)); }
function novaGetSnapshot_(token) {
  if (!/^nova_sheet_[a-f0-9]{64}$/.test(token || '')) throw new Error('کلید اتصال معتبر نیست.');
  const response = UrlFetchApp.fetch(NOVA_ENDPOINT, {
    method: 'get', headers: { Authorization: 'Bearer ' + token },
    muteHttpExceptions: true, followRedirects: false
  });
  const status = response.getResponseCode();
  if (status === 401) throw new Error('کلید باطل یا منقضی شده است؛ کلید جدید بساز.');
  if (status !== 200) throw new Error('ارتباط با نووا برقرار نشد (HTTP ' + status + '). ابتدا انتشار نسخهٔ اتصال را بررسی کن.');
  let data;
  try { data = JSON.parse(response.getContentText()); } catch (_) { throw new Error('پاسخ نووا معتبر نیست.'); }
  if (data.schema_version !== 1 || data.scope !== 'admin' ||
      !data.subject_id || !Array.isArray(data.headers) || data.headers.length !== 11 ||
      !Array.isArray(data.rows) || data.rows.some(row => !Array.isArray(row) || row.length !== 11)) {
    throw new Error('ساختار دادهٔ نووا معتبر نیست.');
  }
  return data;
}
function novaSafeCell_(value) {
  let text = String(value === null || value === undefined ? '' : value);
  if (/^[\s\uFEFF]*[=+@-]/.test(text)) text = "'" + text;
  return text;
}
function novaWrite_(spreadsheet, data) {
  const sheet = spreadsheet.getSheetByName(NOVA_DATA_TAB) || spreadsheet.insertSheet(NOVA_DATA_TAB);
  const rows = [data.headers].concat(data.rows).map(row => row.map(novaSafeCell_));
  // This dedicated tab is replaced; old assignments must not remain at the bottom.
  sheet.clear();
  if (sheet.getMaxRows() < rows.length) sheet.insertRowsAfter(sheet.getMaxRows(), rows.length - sheet.getMaxRows());
  if (sheet.getMaxColumns() < 11) sheet.insertColumnsAfter(sheet.getMaxColumns(), 11 - sheet.getMaxColumns());
  sheet.getRange(1, 1, rows.length, 11).setNumberFormat('@').setValues(rows);
  sheet.setRightToLeft(true).setFrozenRows(1);
  sheet.getRange(1, 1, 1, 11).setBackground('#225db2').setFontColor('#ffffff').setFontWeight('bold');
  sheet.getDataRange().setWrap(true).setVerticalAlignment('top');
  sheet.setColumnWidths(1, 11, 145); sheet.setColumnWidth(11, 230);
  sheet.getRange('A1').setNote('آخرین دریافت موفق: ' + data.generated_at + '\nشیت فقط‌خواندنی است؛ تغییر سلول‌ها اطلاعات نووا را تغییر نمی‌دهد.');
  for (let i = 0; i < data.rows.length; i++) {
    const url = String(data.rows[i][10] || '');
    if (/^https:\/\/nova-academy\.ir\/api\/registrations\/[a-f0-9-]{36}\/receipt$/i.test(url)) {
      sheet.getRange(i + 2, 11).setRichTextValue(SpreadsheetApp.newRichTextValue()
        .setText('مشاهدهٔ فیش خصوصی').setLinkUrl(url).build());
    }
  }
}
function novaStoreConnection_(spreadsheet, token, data, targets) {
  const propertyKey = 'NOVA_TOKEN_' + spreadsheet.getId();
  novaProperties_().setProperty(propertyKey, token);
  const target = { spreadsheetId: spreadsheet.getId(), scope: data.scope,
    subjectId: data.subject_id, label: data.subject_name || 'نووا', tokenProperty: propertyKey };
  novaSaveTargets_(targets.filter(t => t.spreadsheetId !== target.spreadsheetId).concat([target]));
}

function connectNovaAdmin() {
  const token = novaPrompt_('کلید ادمین نووا', 'کلید «ادمین — همهٔ دانش‌آموزها» را از پنل ادمین کپی کن. کلید فقط در تنظیمات خصوصی اسکریپت ذخیره می‌شود.');
  if (token === null) return;
  const data = novaGetSnapshot_(token);
  if (data.scope !== 'admin') throw new Error('برای فایل اصلی فقط کلید ادمین مجاز است.');
  const spreadsheet = SpreadsheetApp.getActiveSpreadsheet();
  novaProperties_().setProperty('NOVA_ADMIN_SPREADSHEET_ID', spreadsheet.getId());
  novaWrite_(spreadsheet, data);
  novaStoreConnection_(spreadsheet, token, data, novaTargets_());
  SpreadsheetApp.getUi().alert('شیت ادمین وصل شد. این فایل و پروژهٔ اسکریپت را با مشاورها به اشتراک نگذار.');
}
function syncAllNovaSheets() {
  const lock = LockService.getScriptLock();
  if (!lock.tryLock(5000)) return;
  try {
    const statuses = [];
    novaTargets_().forEach(target => {
      try {
        const data = novaGetSnapshot_(novaProperties_().getProperty(target.tokenProperty));
        if (data.scope !== target.scope || data.subject_id !== target.subjectId) throw new Error('کلید با صاحب این فایل مطابقت ندارد.');
        novaWrite_(SpreadsheetApp.openById(target.spreadsheetId), data);
        statuses.push([target.label, target.scope, new Date().toISOString(), 'موفق', String(data.rows.length), 'https://docs.google.com/spreadsheets/d/' + target.spreadsheetId + '/edit']);
      } catch (error) {
        // Fail closed for counselor sheets: do not retain stale former assignments on failed/revoked exports.
        if (target.scope === 'counselor') {
          try { const book = SpreadsheetApp.openById(target.spreadsheetId); const tab = book.getSheetByName(NOVA_DATA_TAB); if (tab) tab.clear().getRange('A1').setValue('اتصال فعال نیست؛ ادمین باید آن را بررسی کند.'); } catch (_) {}
        }
        statuses.push([target.label, target.scope, new Date().toISOString(), String(error.message), '', '']);
      }
    });
    const masterId = novaProperties_().getProperty('NOVA_ADMIN_SPREADSHEET_ID');
    if (masterId) {
      const book = SpreadsheetApp.openById(masterId);
      const tab = book.getSheetByName(NOVA_STATUS_TAB) || book.insertSheet(NOVA_STATUS_TAB);
      tab.clear(); tab.setRightToLeft(true);
      const rows = [['نام اتصال', 'نوع دسترسی', 'زمان بررسی', 'وضعیت', 'تعداد ردیف', 'فایل']].concat(statuses);
      tab.getRange(1, 1, rows.length, 6).setNumberFormat('@').setValues(rows.map(row => row.map(novaSafeCell_)));
      tab.setFrozenRows(1); tab.getRange(1, 1, 1, 6).setFontWeight('bold'); tab.setColumnWidths(1, 6, 180);
    }
  } finally { lock.releaseLock(); }
}
function syncNovaNow() { syncAllNovaSheets(); SpreadsheetApp.getUi().alert('بررسی انجام شد؛ نتیجه در برگهٔ «وضعیت اتصال» نمایش داده می‌شود.'); }
function installNovaHourlySync() {
  if (!novaTargets_().length) throw new Error('ابتدا حداقل یک شیت را وصل کن.');
  ScriptApp.getProjectTriggers().filter(t => t.getHandlerFunction() === 'syncAllNovaSheets').forEach(t => ScriptApp.deleteTrigger(t));
  ScriptApp.newTrigger('syncAllNovaSheets').timeBased().everyHours(1).create();
  SpreadsheetApp.getUi().alert('به‌روزرسانی ساعتی فعال شد. تغییرات شیت فوری نیست؛ برای دریافت فوری از «به‌روزرسانی اکنون» استفاده کن.');
}
function replaceNovaKey() {
  const id = novaPrompt_('شناسهٔ فایل', 'شناسهٔ فایل را از URL بین /d/ و /edit کپی کن.'); if (id === null) return;
  const targets = novaTargets_(); const target = targets.find(t => t.spreadsheetId === id);
  if (!target) throw new Error('این فایل در اسکریپت متصل نیست.');
  const token = novaPrompt_('کلید تازه', 'کلید تازهٔ همان ادمین یا همان مشاور را وارد کن.'); if (token === null) return;
  const data = novaGetSnapshot_(token);
  if (data.scope !== target.scope || data.subject_id !== target.subjectId) throw new Error('کلید متعلق به این فایل نیست.');
  novaWrite_(SpreadsheetApp.openById(id), data);
  novaStoreConnection_(SpreadsheetApp.openById(id), token, data, targets);
  SpreadsheetApp.getUi().alert('کلید تعویض شد. لینک این فایل را مقابل کلید تازه در پنل نووا ثبت و کلید قبلی را باطل کن.');
}
