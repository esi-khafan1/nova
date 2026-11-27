export function RenewalNotice({ payment = false }: { payment?: boolean }) {
  return <aside className="renewal-notice" aria-label="تخفیف تمدید دانش‌آموزان نووا">
    <span className="renewal-notice-percent" aria-hidden="true">۱۵٪</span>
    <div className="renewal-notice-copy">
      <strong>۱۵ درصد تخفیف برای تمدید دوره</strong>
      <span>{payment
        ? "دانش‌آموز نووا هستی و قصد تمدید داری؟ کد تخفیفت را همین‌جا وارد و اعمال کن تا مبلغ جدید را ببینی."
        : "دانش‌آموز نووا هستی و قصد تمدید داری؟ با حساب دانش‌آموزی‌ات وارد شو و کد تخفیفت را در بخش واریز اعمال کن."}</span>
    </div>
  </aside>;
}
