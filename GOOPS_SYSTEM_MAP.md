# نقشه سامانه گُوپس (GOOPS System Map)

## مستندات مرجع موجود
- `ANALYSIS.md`: تحلیل معماری، جریان‌های کاربری و ریسک‌های اصلی سیستم را توضیح می‌دهد.
- `ROADMAP.md`: نقشه راه فنی و فازهای بومی‌سازی و توسعه را تشریح کرده است.
- `TEST_SCENARIOS.md`: سناریوهای تست برای نقش‌های مشتری، مامان و ادمین را فهرست می‌کند.
- `FINAL_CHECKLIST.md`: چک‌لیست نهایی برای اطمینان از تکمیل نیازمندی‌های فنی و UX.
- `QA_EVALUATION.md`: ارزیابی کیفیت، باگ‌های احتمالی و تحلیل عملکرد تیم/ایجنت را مستند کرده است.

## نمای کلی معماری
- **Backend & Backoffice (Yii/PHP):** مسیر `codecanyon-9118694-karenderia-multiple-restaurant-system/`. این ماژول همزمان نقش API، پنل ادمین و هسته تجاری را بر عهده دارد و روی پایگاه داده MySQL کار می‌کند.
- **برنامه‌های Quasar/Vue (Hybrid Apps):** هر اپلیکیشن موبایل با Quasar ساخته شده است (`MobileVue`, `MerchantVue`, `DriverVue`, `KicthenMobile`) و از طریق Capacitor/Cordova می‌تواند خروجی موبایل و PWA تولید کند.
- **پایگاه داده:** فایل `karenderia.sql` ساختار دیتابیس را ارائه می‌کند و پیش‌فرض آن جدول‌های با پیشوند `st_` است.
- **Realtime & Notifications:** اتکا به Pusher، Firebase و سرویس‌های Push مبتنی بر Capacitor برای اعلان‌های لحظه‌ای.
- **SMS & Email Gateways:** استفاده از Twilio و Nexmo/Vonage برای پیامک، و SendGrid/Twilio برای ایمیل در هسته PHP.
- **پرداخت و سرویس‌های خارجی:** ماژول‌های Stripe، PayPal، Razorpay، Mercadopago و درگاه‌های دیگر در پوشه `protected/modules/` موجودند؛ برای بازار ایران درگاه جایگزین (مثلاً زرین‌پال) باید جایگزین شود.
- **سرویس نقشه:** کامپوننت‌های فرانت‌اند فعلی بر پایه Google Maps (`vue3-google-map`) هستند و در بک‌اند نیز نگاشت مناطق به نقشه وابسته به API‌های خارجی است.

## فهرست سرویس‌ها و اپلیکیشن‌ها

| سرویس / اپ | مسیر پوشه | تکنولوژی و لایه | کاربران اصلی | وابستگی‌های خارجی کلیدی | توضیحات مکمل |
| --- | --- | --- | --- | --- | --- |
| سیستم مرکزی و پنل مدیریت (Karenderia MRS) | `codecanyon-9118694-karenderia-multiple-restaurant-system/` | PHP (Yii MVC)، قالب‌های `themes/karenderia_v2`, پنل `backoffice/` | ادمین، مامان‌ها (از طریق backoffice)، پشتیبان | Twilio SMS (`protected/components/CSMSsender.php`)، Nexmo/Vonage (`protected/vendor/nexmo/`)، Pusher Beams (`service-worker.js`)، Firebase (اسکریپت‌های `assets/js/*`)، Google Maps/Mapbox (باندل پنل)، درگاه‌های Stripe/PayPal/Razorpay/MercadoPago (`protected/modules/`) | شامل کنترلر API (`protected/controllers/ApiController.php`)، مدیریت سفارش/کاربر، تنظیمات سیستم و فایل‌های ترجمه. |
| REST API عمومی | `protected/controllers/ApiController.php` داخل سیستم مرکزی | Endpointهای JSON برای مشتری، مامان و راننده | تمام کلاینت‌ها (اپ مشتری، مامان، راننده، KDS) | به پیکربندی‌های احراز هویت JWT و Firebase و نیز پرداخت متصل است | متدهای متعددی برای ورود، سفارش، پرداخت، پیگیری وضعیت و ... |
| پایگاه داده | `karenderia.sql` | MySQL/MariaDB | ادمین‌های فنی، DevOps | اتصال به ماژول‌های پرداخت و گزارش‌گیری | شامل Seed اولیه و ساختار جدول‌های سفارش، کاربران، آیتم‌ها، ترجمه و ... |
| اپلیکیشن مشتری | `codecanyon-40502711-karenderia-mobile-app-multi-restaurant/MobileVue/` | Quasar 2 + Vue 3، Capacitor، Pinia، PWA | مشتری نهایی (خریدار) | `vue3-google-map` برای نقشه، `firebase` و `@capacitor/push-notifications` برای پوش نوتیفیکیشن، `pusher-js` برای رویدادهای بلادرنگ، افزونه‌های پرداخت در مرورگر | از طریق `src/boot/axios` به API متصل می‌شود، قابلیت ثبت سفارش، پرداخت و پیگیری دارد. |
| اپلیکیشن مامان/فروشنده | `codecanyon-42215908-karenderia-merchant-app-restaurant/MerchantVue/` | Quasar 2 + Vue 3، Capacitor، Pinia | مامان‌ها/فروشندگان | `firebase`، `pusher-js`، پشتیبانی چاپگر حرارتی (`thermal-printer-encoder`)، بارکد اسکنر (`@capacitor-mlkit/barcode-scanning`)، سرویس‌های BLE برای پرینتر | داشبورد فروشنده برای مدیریت منو، سفارش، گزارش و اعلان‌ها. |
| اپلیکیشن راننده | `codecanyon-44025705-karenderia-driver-app/DriverVue/` | Quasar 2 + Vue 3، Capacitor | رانندگان ارسال | `firebase` برای ردیابی لحظه‌ای، `vue3-google-map` برای مسیریابی، پلاگین‌های دوربین و لوکیشن دقیق، Push Notifications | مدیریت ماموریت‌های تحویل، ثبت موقعیت زنده و ارتباط با مشتری/مامان. |
| سیستم نمایش آشپزخانه (KDS) | `codecanyon-53130431-karenderia-kitchen-display-system/KicthenMobile/` | Quasar 2 + Vue 3، Capacitor | آشپزخانه/عملیات داخلی مامان | `firebase`/`pusher-js` برای اعلان سفارش، پشتیبانی پرینتر بلوتوث (`cordova-plugin-btprinter`)، شبکه داخلی | نمایش لحظه‌ای سفارش‌ها، وضعیت آماده‌سازی و هماهنگی با راننده. |
| ماژول‌های موبایل اشتراکی | `*/MobileModules`, `MerchantModules`, `DriverModules`, `KitchenModules` | Pluginهای Cordova/Capacitor مشترک، تنظیمات build | تیم فنی | دسترسی به سرویس‌های native (GPS، نوتیفیکیشن، پرداخت درون‌برنامه) | بسته‌های کمکی برای بیلد موبایل (Android/iOS). |
| اسناد و مستندات | `duciment/` و PDFهای هر محصول | فایل‌های PDF و TXT | تیم محصول/فنی | - | شامل راهنماهای رسمی Codecanyon برای نصب و پیکربندی. |

## وابستگی‌های خارجی پرتکرار
- **نقشه و مکان:** Google Maps (`vue3-google-map` در همه اپ‌های Vue)، Mapbox در پنل مدیریت، نیاز به جایگزینی با سرویس داخلی (نشان/بلد).
- **پرداخت:** Stripe، PayPal، Razorpay، Mercadopago در هسته، که برای ایران باید با زرین‌پال یا شاپرک جایگزین شوند.
- **پیامک و ایمیل:** Twilio (SMS و SendGrid)، Nexmo/Vonage.
- **اعلان‌ها و بلادرنگ:** Firebase (Firestore و Messaging)، Pusher (Beams/WebSocket)، Capacitor Local Notifications.
- **هویت اجتماعی:** Google/Facebook Login (پکیج‌های Capacitor در اپ‌ها).

## نکات کلیدی برای بومی‌سازی ایران
1. **زیرساخت نقشه:** فراهم کردن لایه انتزاعی برای جایگزینی سرویس‌های نقشه گوگل با گزینه داخلی.
2. **درگاه پرداخت:** توسعه ماژول پرداخت محلی و غیر فعال‌سازی ماژول‌های غیرفعال در ایران.
3. **ارسال پیامک:** بررسی سرویس‌های پیامکی ایرانی و جایگزینی با ماژول Twilio/Nexmo در هسته.
4. **اعلان‌ها:** بررسی امکان استفاده از Firebase در ایران یا تهیه آلترناتیو (مثلاً OneSignal با سرور پراکسی).
5. **تاریخ و زبان:** هماهنگ‌سازی تاریخ شمسی و ترجمه‌ها در تمام لایه‌ها (Backend + اپ‌های Quasar).
