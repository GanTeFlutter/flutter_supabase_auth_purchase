https://supabase.com/docs/guides/getting-started/tutorials/with-flutter?queryGroups=platform&platform=android&queryGroups=database-method&database-method=dashboard


Bir uygulama içi öğenin satın alma ve tüketim durumunu kontrol eder.
https://developers.google.com/android-publisher/api-ref/rest/v3/purchases.products/get?hl=tr


Pusrchasing
📋 Akış Şeması
1️⃣ Uygulama Başladığında (PurchaseView açıldığında)
PurchaseView açılır
    ↓
_PurchaseViewState oluşur
    ↓
PurchasingViewMixin devreye girer
    ↓
Mixin'in initState() çalışır
    ↓
PurchasingService.initialize() çağrılır
2️⃣ Service Initialize Olurken
dartPurchasingService.initialize():
  1. Play Billing mevcut mu kontrol et (_available)
  2. Ürün ID'lerini sorgula ('supa1tl')
  3. Ürünleri _products listesine kaydet
  4. purchaseStream'i dinlemeye başla
3️⃣ Kullanıcı Satın Alma Yaptığında
Kullanıcı ürüne tıklar
    ↓
ListTile.onTap → buyProduct(product) çağrılır
    ↓
Mixin'deki buyProduct → Service'teki buyProduct'ı çağırır
    ↓
Service → InAppPurchase.buyNonConsumable() çağrılır
    ↓
Google Play Billing devreye girer
4️⃣ Satın Alma Sonuçlandığında
purchaseStream yeni bir event yayınlar
    ↓
Service'teki listener tetiklenir
    ↓
onPurchaseUpdate callback çağrılır
    ↓
Mixin'deki _handlePurchaseUpdate çalışır
    ↓
View'deki onPurchaseUpdate override'ı çalışır
    ↓
Kullanıcıya geri bildirim ver

🔄 Veri Akışı
[InAppPurchase API]
        ↕️
[PurchasingService] ← İş mantığı burada
        ↕️
[PurchasingViewMixin] ← State yönetimi burada
        ↕️
[PurchaseView] ← Sadece UI burada