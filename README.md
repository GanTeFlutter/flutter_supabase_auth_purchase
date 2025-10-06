
Flutter supabase in_app_purchase ile satın alma aut ve bu satın almayı supabase function üzerinden doğrulama yaptığım bir proje

Bu projeyi çalıştırabilmek için öncelikle Play Console bir proje yüklemelisiniz bunun için bazı kaynaklar.
https://codelabs.developers.google.com/codelabs/flutter-in-app-purchases?hl=tr#0

uygulamayı imzlamak için Android studio ile direk yapabilirsiniz!
https://docs.flutter.dev/deployment/android

!Alınması gereken izinler!

 Google Cloud 
  Öncelikle playconsolda bir kapalı veya açık test başlatın sonrasında bu projeyi CloudConsole dan seçtin 

  soldaki menüden Service Accounts > Create service account>(Permissions kısmında Select a role kısmından Service Accounts> Service Account Token Creator) secin  devam edin aktif edilmiş olarak mail orada gözükecek 

  bu mailinen sağında ki üç nokta>Manage Keys>Add key>Create new key>Json>Create diyerek Json dosyasini indirin 
  (bu supabase tarafında play consola istek atarken bak ben buyum sana istek atıyorum demek için bir nevi kendimi tanıtmak için kullanılacak.)
  
  ardından Tekrar ana sayfaya gelerek  APIs & Services >API Library den Google Play Android Developer API aktif edin
  
  Google Cloud tarafında işlemler bu kadar 



Play Console Tarafı
Ana sayfa  >Kullanıcı Ve izinler>  Uygulamayı seçip izinleri yönet >

Finansal veri	Finansal verileri görüntüleme >iznini aktif edin 



🔹 Supabase Tarafı

Login/Auth kısmı en altta bununan supabase doc linki ile aynı o yüzden ordan tüm işlemleri tamamlayın giriş işlemi tamamlanması lazım çünkü sopabaseFunctiona giriş yapmış kullanıcın id sini gönderiyoruz bunulada premium durumunu ture çekiyoruz tabi ki play console tarafındak doğrulama gelirse...

Edge Function oluşturma:
Satın alma doğrulaması için Supabase üzerinde bir Edge Function oluşturulur.
Bu fonksiyon, Google Play API’ye güvenli şekilde istek atmak için kullanılır.

Service Account JSON Key ekleme:
Google Cloud’dan alınan .json key, Supabase Dashboard → Edge Functions → Configuration → Add new secret kısmına eklenir:

Key: GOOGLE_SERVICE_ACCOUNT
Value: (JSON dosyasının tüm içeriği) Bunu almıştık 
eğer bu şekilde çalıştırırken  hata alıyorsanız direkt functionun içinde kullanın ama doğrusu yukarıda yazan 



Eğer yapan olursa mesaj atsın profilimde instagram linki var yardımcı olrum <3




supabase Kullanıcı Giriş kısmının Kurulum Dosyası Alltaki tutorials ile benim kodlarım aynıdır belki bi service yapmışımdır o kadar.
https://supabase.com/docs/guides/getting-started/tutorials/with-flutter?queryGroups=platform&platform=android&queryGroups=database-method&database-method=dashboard


Bir uygulama içi öğenin satın alma ve tüketim durumunu kontrol eder.
yani supabaseFuntion tarafında play consoldan doğrulama yaparken alltaki kodu göndereceğiz(içini doldurup)
https://developers.google.com/android-publisher/api-ref/rest/v3/purchases.products/get?hl=tr
https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/purchases/products/{productId}/tokens/{token}





📦 Kullanılan Paketler
💰 Satın Alma

in_app_purchase → Google Play üzerinden uygulama içi ürün ve abonelik işlemleri.

🗄️ Backend

supabase_flutter → Kullanıcı, veritabanı ve edge function yönetimi.

🧠 State Management

flutter_bloc → Uygulama durum yönetimi (BLoC yapısı).

get_it → Servis locator (bağımlılık yönetimi).

🧰 Araçlar

logger → Loglama ve hata ayıklama.

envied / envied_generator → Ortam değişkenleri (.env) yönetimi.

uuid → Benzersiz kimlik üretimi.

meta → Kod açıklama anotasyonları.

package_info_plus → Uygulama sürüm bilgileri.

🧭 Navigasyon

go_router → Sayfa yönlendirme ve route yönetimi.

🌐 Ağ / API

dio → HTTP istekleri ve API entegrasyonu.

build_runner → Kod üretimi araçları (envied vb.).
