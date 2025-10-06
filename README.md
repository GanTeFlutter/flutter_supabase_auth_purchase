# Flutter — In‑App Purchase (Google Play) + Supabase Edge Function ile Doğrulama

> Bu repo, **Google Play (in_app_purchase)** ile yapılan uygulama içi satın alımlarının **Supabase Edge Function** kullanılarak güvenli şekilde doğrulanmasını anlatır ve örnek kod/ayarlar içerir.

---

## Öne Çıkanlar

* Google Play üzerinden satın alma işlemi (`in_app_purchase` paketi) ile entegrasyon.
* Satın alma token'ının Sunucu tarafında **Supabase Edge Function** aracılığıyla Google Play Developer API ile doğrulanması.
* Google Cloud Service Account JSON anahtarının Supabase'e **secret** olarak yüklenmesi.
* Adım adım Play Console, Google Cloud ve Supabase yapılandırma rehberi.

---

## İçindekiler

* [Gereksinimler](#gerek-kenimler)
* [Play Console — Hızlı Ayarlar](#play-console--h%C4%B1zl%C4%B1-ayarlar)
* [Google Cloud — Service Account Oluşturma](#google-cloud--service-account-olu%C5%9Fturma)
* [Supabase — Edge Function & Secret Ayarları](#supabase--edge-function--secret-ayarlari)
* [Kullanılan Paketler](#kullan%C4%B1lan-paketler)
* [Örnek Fonksiyon Çağrısı & API Endpoint](#%C3%B6rnek-fonksiyon-%C3%A7a%C4%9Fr%C4%B1s%C4%B1--api-endpoint)
* [Uygulamayı İmzalama & Yayına Hazırlama](#uygulamayi-izmalama--yayina-hazirlama)
* [Test Etme / Kapalı Test Kullanıcıları](#test-etme--kapali-test-kullanicilari)
* [Notlar & İletişim](#notlar--iletisim)

---

## Gereksinimler

* Flutter ortamı (stable channel)
* Android Studio (uygulamayı imzalamak için önerilir)
* Play Console hesabı
* Google Cloud projesi (Play Console ile aynı proje tercih edilir)
* Supabase hesabı ve proje

---

## Play Console — Hızlı Ayarlar

1. Play Console'da **kapalı** veya **açık test** başlatın.
2. **Kullanıcı ve izinler** bölümünden uygulama için gerekli yetkileri verin:

   * **Finansal veri**: `Finansal verileri görüntüleme` iznini aktif edin.

> Play Console tarafındaki satın alma verisine erişim için doğru izinler şarttır.

---

## Google Cloud — Service Account Oluşturma

1. `Google Cloud Console` → **IAM & Admin** → **Service Accounts** → **Create service account**
2. Permissions kısmında **Service Accounts > Service Account Token Creator** rolünü seçin.
3. Oluşturduktan sonra ilgili Service Account satırında üç nokta → **Manage keys** → **Add key** → **Create new key** → **JSON** indirin.
4. `APIs & Services` → **API Library** üzerinden **Google Play Android Developer API**'yi aktif edin.

> Bu JSON dosyası, Supabase fonksiyonunun Google Play API'ye kimlik doğrulamalı istek atması için kullanılacak.

---

## Supabase — Edge Function & Secret Ayarları

1. Supabase Dashboard → **Edge Functions** → Yeni fonksiyon oluşturun (ör: `verify_purchase`).
2. Fonksiyon içinde Google Play API çağrısını yapacak kodu yazın (örn. Node.js/TypeScript veya Deno).
3. Dashboard → Edge Functions → **Configuration** → **Add new secret** ekleyin:

   * **Key:** `GOOGLE_SERVICE_ACCOUNT`
   * **Value:** (Google Cloud'dan indirdiğiniz JSON içeriğinin tamamı)

> Eğer secret olarak eklerken hata alıyorsanız, geçici çözüm olarak JSON içeriğini doğrudan fonksiyon içinde kullanabilirsiniz. (Güvenlik açısından tavsiye edilmez.)

### Fonksiyonun Yapacağı İşler (özet)

* İstemciden gelen: `userId`, `packageName`, `productId`, `purchaseToken`.
* Fonksiyon, Google Play API endpoint'ine istek atar:

  ```
  GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/purchases/products/{productId}/tokens/{token}
  ```
* Google Play doğrulaması başarılıysa Supabase veritabanında ilgili kullanıcının `premium` veya satın alma bilgisini günceller.

> Google dökümantasyonu: `purchases.products.get`. (Bu URL kullanılır.)

---

## Örnek Edge Function (kısa şablon — Deno/TypeScript)

```ts
// örnek: verify_purchase/index.ts
import { serve } from "std/server";
import { google } from "googleapis"; // Deno'da farklı olabilir

serve(async (req) => {
  const body = await req.json();
  const { packageName, productId, token, userId } = body;

  // GOOGLE_SERVICE_ACCOUNT secret'ını kullanarak JWT/credentials oluşturun
  // google.auth.JWT veya uygun auth flow ile Play Developer API'ye istek atın

  // Endpoint:
  // https://androidpublisher.googleapis.com/androidpublisher/v3/applications/${packageName}/purchases/products/${productId}/tokens/${token}

  // Dönen sonucu kontrol edip Supabase veritabanını güncelleyin

  return new Response(JSON.stringify({ ok: true }), { status: 200 });
});
```

> Not: Üstteki kod Deno/Node farkı ve kütüphane kullanımına göre uyarlanmalıdır. Resmi Google API client kitaplıkları tercih edin.

---

## Kullanılan Paketler (Flutter tarafı)

```
in_app_purchase
supabase_flutter
flutter_bloc
get_it
logger
envied
uuid
meta
package_info_plus
go_router
dio
build_runner
```

---

## Uygulamayı İmzalama & Yayına Hazırlama

* Uygulamayı Android Studio veya `flutter build appbundle --release` ile imzalayıp .aab oluşturun.
* Flutter resmi deployment rehberi: [https://docs.flutter.dev/deployment/android](https://docs.flutter.dev/deployment/android)

---

## Test Etme / Kapalı Test Kullanıcıları Veya Dahili Testte Olur

* Play Console'da test hesabı ekleyin.
* Cihazınızda test hesabıyla Play Store'dan uygulamanın test sürümünü yükleyin.
* Satın alma işlemlerini test kullanıcılarıyla deneyin.

---

## Faydalı Kaynaklar

* Google Codelab (Flutter in-app purchases):
  [https://codelabs.developers.google.com/codelabs/flutter-in-app-purchases?hl=tr#0](https://codelabs.developers.google.com/codelabs/flutter-in-app-purchases?hl=tr#0)
* Supabase Flutter Tutorial:
  [https://supabase.com/docs/guides/getting-started/tutorials/with-flutter?queryGroups=platform&platform=android&queryGroups=database-method&database-method=dashboard](https://supabase.com/docs/guides/getting-started/tutorials/with-flutter?queryGroups=platform&platform=android&queryGroups=database-method&database-method=dashboard)
* Google Play Purchases API reference:
  [https://developers.google.com/android-publisher/api-ref/rest/v3/purchases.products/get?hl=tr](https://developers.google.com/android-publisher/api-ref/rest/v3/purchases.products/get?hl=tr)

---

## Kurulum Kontrol Listesi (Checklist)

* [ ] Play Console test veya üretim ortamı oluşturuldu
* [ ] Google Cloud Service Account oluşturuldu ve JSON indirildi
* [ ] Google Play Android Developer API etkinleştirildi
* [ ] Service Account JSON Supabase'e `GOOGLE_SERVICE_ACCOUNT` secret olarak eklendi
* [ ] Supabase Edge Function yazıldı ve deploy edildi
* [ ] Flutter uygulamasında `in_app_purchase` ile satın alma akışı entegre edildi
* [ ] Satın alma token'ı Supabase fonksiyonuna gönderiliyor ve doğrulanıyor

---

## Notlar & İletişim

Eğer bu rehberi uygularken takılırsanız profilimdeki Instagram üzerinden mesaj atabilirsiniz — yardımcı olurum ❤️

