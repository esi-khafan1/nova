import { LegalPage } from "@/components/legal/legal-page";
export default function ContactPage() {
  return (
    <LegalPage title="تماس با ما" eyebrow="پشتیبانی نووا">
      <p>
        برای پرسش درباره حساب کاربری، خدمات مشاوره، پرداخت یا حریم خصوصی از طریق
        ایمیل رسمی نووا با ما در ارتباط باشید.
      </p>
      <div className="legal-contact">
        <span>ایمیل پشتیبانی</span>
        <a dir="ltr" href="mailto:support@nova-academy.ir">
          support@nova-academy.ir
        </a>
      </div>
      <p>
        پس از دریافت پیام، درخواست در اولین فرصت کاری بررسی می‌شود. شماره تماس و
        نشانی حضوری پس از تعیین کانال رسمی پشتیبانی در این صفحه اعلام خواهد شد.
      </p>
    </LegalPage>
  );
}
