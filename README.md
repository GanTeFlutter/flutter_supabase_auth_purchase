

Şu anda bu kısmı düzenliyorum adı adım rehberi yazağım!!!!!!

supabase Auth Kurulum Doc.

https://supabase.com/docs/guides/getting-started/tutorials/with-flutter?queryGroups=platform&platform=android&queryGroups=database-method&database-method=dashboard


PlayConsole Doğrulama Link
https://developers.google.com/android-publisher/api-ref/rest/v3/purchases.products/get?hl=tr


Google Cloud Console'a gidin: https://console.cloud.google.com/

Sağ üstteki proje seçiciden 996642045521 ID'li projenizin seçili olduğundan emin olun.

Sol menüden "APIs & Services" (API'ler ve Hizmetler) → "Library" (Kitaplık) kısmına gidin.

Arama çubuğuna "Google Play Android Developer API" yazın.

API'yi bulun ve sayfasına girerek "ENABLE" (Etkinleştir) butonuna basın.


🔹 Supabase Tarafı

Edge Function oluşturma:
Satın alma doğrulaması için Supabase üzerinde bir Edge Function oluşturulur.
Bu fonksiyon, Google Play API’ye güvenli şekilde istek atmak için kullanılır.

Service Account JSON Key ekleme:
Google Cloud’dan alınan .json key, Supabase Dashboard → Edge Functions → Configuration → Add new secret kısmına eklenir:

Key: GOOGLE_SERVICE_ACCOUNT
Value: (JSON dosyasının tüm içeriği)


Fonksiyon deploy:

supabase functions deploy rapid-function


İşlevi:
Edge Function, gelen satın alma token’larını Google Play API’ye doğrulatır ve sonucu döndürür.


🛠️ Google Play Hizmet Hesabı İzinlerini Ayarlama Rehberi
Bu adımlar, Google Play Console'da Hizmet Hesabınızın (e-posta adresi @...gserviceaccount.com ile biten) finansal verilere erişim iznini almanızı sağlar.

Bölüm 1: Hizmet Hesabını Kullanıcı Olarak Ekleme
Öncelikle, Hizmet Hesabınızın Google Play Console'da bir kullanıcı olarak tanımlanması gerekir.

Giriş: Google Play Console'a giriş yapın.

Menüye Gitme: Sol menüden Kurulum (Setup) → Kullanıcılar ve izinler (Users and permissions) bölümüne gidin.

Hizmet Hesabını Davet Etme:

Sayfanın üst kısmında "Yeni kullanıcı davet et" (Invite new user) butonuna tıklayın.

Davet edilecek e-posta adresine, Edge Function'ınızın bağlı olduğu Google Cloud projesindeki Hizmet Hesabının e-postasını (client_email) yapıştırın (Örn: play-verifications@...gserviceaccount.com).

Daveti Onaylama: Kullanıcıyı ekledikten sonra, listede yeni eklediğiniz Hizmet Hesabına tıklayarak izin ayarları sayfasına gidin.

Bölüm 2: Finansal Veri İznini Verme
Bu, 401 Permission Denied hatasını doğrudan çözen asıl adımdır.

İzinler Sayfasında Kaydırma: Hizmet Hesabınızın ayarları sayfasında (Kullanıcı Bilgileri ve Erişim Süresi kısmı olan sayfada) aşağı doğru kaydırın.

"Hesap İzinleri"ni Bulma: "Hesap izinleri" (Account permissions) başlığını bulun.

"Finansal Veri" Başlığı Altına Odaklanma: Hesap izinleri listesinde "Finansal veri" (Financial data) başlığını bulun.

İzni İşaretleme: Bu başlığın hemen altındaki şu izni mutlaka işaretleyin (seçin):

✅ Finansal verileri, siparişleri ve iptal anketine verilen yanıtları görüntüleme

(Bu izin, Satın Alma İşlemleri API'sine erişim yetkisini içerir.)

Kaydetme: Sayfanın altındaki Kaydet (Save) veya Uygula (Apply) butonuna tıklayarak yaptığınız değişiklikleri onaylayın ve kaydedin.



🔹 Flutter Tarafı

Ürün ekleme:

Google Play Console → Monetization → Products → In-app products

Ürün ID’si (ör. supa1tl) ve fiyat bilgisi girilir.

Yayınla ve uygulama içinde kullanılabilir hâle getir.

PurchasingService:

Play Billing mevcut mu kontrol edilir.

Ürün ID’leri sorgulanır.

Ürünler _products listesine kaydedilir.

purchaseStream dinlenir ve satın alma sonuçları işlenir.




--
