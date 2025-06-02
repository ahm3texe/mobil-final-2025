🏨 Hotel Explorer

 

 

 

Hotel Explorer, konaklama seçeneklerini keşfetmenizi, favorilerinizi saklamanızı ve birden fazla oteli ayrıntılı ölçütlerle karşılaştırmanızı sağlayan açık kaynaklı bir Flutter + Firebase uygulamasıdır. Mobil odaklı tasarlanan proje; güvenli kimlik doğrulama, gerçek-zamanlı veri güncellemeleri ve çevrimdışı önbellekleme özellikleri sunar.

⸻

🚀 Projenin Amacı

Seyahate çıkmadan önce onlarca sekme arasında kaybolmak yerine tek bir yerden en uygun oteli bulmanızı hedefliyoruz. Hotel Explorer, otelleri; fiyat, puan, konum ve olanaklar bakımından filtreleyip karşılaştırır, favorilerinizi saklar ve not almanıza imkân tanır.

⸻

🎯 Öne Çıkan Özellikler
	•	Firebase Authentication ile e-posta / Google oturum açma
	•	Gerçek-zamanlı otel verisi & kullanıcı favorileri (Cloud Firestore)
	•	Çevrimdışı önbellek ve local_storage_service ile hızlı açılış
	•	Otel karşılaştırma modülü — fiyat, puan, olanak çizelgesi
	•	Tema ayarları (karanlık / aydınlık) ve sezgisel UI
	•	Brandfetch API ile otel/logo görselleri
	•	Responsive tasarım (telefon & tablet)
	•	Not alma özelliği (isteğe bağlı modül)

⸻

🛠️ Kurulum

# 1. Depoyu klonla
git clone https://github.com/<kullanici>/hotel_explorer.git
cd hotel_explorer

# 2. Paketleri indir
flutter pub get

# 3. Firebase'i kur
flutterfire configure  # firebase_options.dart oluşturur

# 4. Uygulamayı çalıştır
flutter run # bağlı cihaz / emülatör

Gereksinimler: Flutter 3.22.1 (stable), Dart 3.2.0, Firebase CLI v13+, Android Studio Giraffe veya VS Code + Flutter eklentisi.

⸻

🔰 Kullanım

Akış	GIF / Ekran	Açıklama
Giriş	assets/demo/login.gif	Kullanıcı e-posta & şifre ile oturum açar
Otel Keşfet	assets/demo/browse.gif	Konum/fiyat filtreleri, sonsuz kaydırma
Detay	assets/demo/detail.gif	Fotoğraf galerisi, harita & yorumlar
Karşılaştır	assets/demo/compare.gif	Seçili otelleri yan yana karşılaştırır
Favoriler	assets/demo/favorites.gif	Sık kullanılan oteller listesi

Demo medya dosyaları assets/demo/ altında tutulur – CI pipeline’ınızda otomatik optimize edilir.

⸻

🖼️ Ekran Görüntüleri

Login	Anasayfa	Detay	Karşılaştırma
			


⸻

📐 Mimarî ve Teknik Detaylar

Kullanılan Teknolojiler

Teknoloji	Sürüm	Amaç
Flutter SDK	3.22.1	UI & iş mantığı
Dart	3.2.0	Programlama dili
Firebase Authentication	5.17.1	Kimlik doğrulama
Cloud Firestore	5.15.1	Gerçek-zamanlı NoSQL veritabanı
Provider	6.1.1	Durum yönetimi
HTTP	1.2.1	REST istekleri
Brandfetch API	v5	Logo & marka verisi
image_picker	1.1.0	Galeri / kamera

Katmanlı Yapı

lib/
 ├── core/           # app_theme, app_router, constants
 ├── models/         # hotel.dart, user_model.dart …
 ├── services/       # auth_service.dart, hotel_service.dart …
 ├── providers/      # theme_provider.dart, compare_provider.dart …
 ├── widgets/        # reusable UI bileşenleri
 ├── pages/
 │   ├── auth/       # login_page.dart, register_page.dart
 │   └── home/       # home_page.dart, hotel_detail_page.dart …
 └── main.dart       # entrypoint

Sayfalar ve Görevleri

Dosya	Açıklama
main.dart	Uygulamanın giriş noktası; Provider’lar & router
home_page.dart	Ana keşif sayfası
hotel_detail_page.dart	Otel ayrıntıları & rezervasyon
favorites_page.dart	Favori oteller
comparison_page.dart	Otel karşılaştırma matrisi
about_page.dart	Uygulama / ekip bilgisi
contact_page.dart	İletişim formu
login_page.dart	Oturum açma
register_page.dart	Hesap oluşturma
forgot_password_screen.dart	Şifre sıfırlama
notes_screen.dart	Kişisel notlar (opsiyonel)
add_note_screen.dart	Yeni not modalı
settings_screen.dart	Tema & profil

Servisler

Dosya	Tip	Sorumluluk
auth_service.dart	Service	Firebase Authentication işlemleri
favorite_service.dart	Service	Kullanıcının favori otellerini yönetir
hotel_service.dart	Service	Otel verilerini API’den çeker & filtreler
local_storage_service.dart	Service	Çevrimdışı önbellek
firestore_service.dart	Service	Cloud Firestore CRUD
logo_provider.dart	Provider	Brandfetch API
theme_provider.dart	Provider	Tema yönetimi
compare_provider.dart	Provider	Karşılaştırma listesi

Veri Modelleri

Model	Alanlar
hotel.dart	id, name, location, price, rating, images, amenities
user_model.dart	uid, email, displayName, photoUrl, favorites

Widgetlar

Widget	Açıklama
custom_app_bar.dart	Özelleştirilmiş üst menü
custom_drawer.dart	Yan menü & profil kartı
hotel_card.dart	Özet otel kartı
hotel_list_card.dart	Liste görünümü kartı


⸻

🔒 Güvenlik & Veri Saklama
	•	Parola ve oturum anahtarları cihazda saklanmaz, Firebase tarafında korunur.
	•	Tüm ağ çağrıları HTTPS üzerinden gerçekleştirilir.
	•	Firestore verileri, yalnızca giriş yapmış kullanıcının kendi favorilerine erişebileceği şekilde güvenlik kurallarıyla sınırlandırılmıştır.
	•	Yerel önbellek (SharedPreferences) şifrelenmiş olarak tutulur.

Örnek Firestore dokümanı:

// Koleksiyon: hotels
{
  "id": "otel_123",
  "name": "Sea Breeze Resort",
  "location": "Antalya, Türkiye",
  "price": 135.00,
  "rating": 4.6,
  "amenities": ["wifi", "pool", "parking"],
  "images": ["https://.../1.jpg", "https://.../2.jpg"],
  "createdAt": 1717305600000
}


⸻

🗄️ Veritabanı Tasarımı

Koleksiyon	DokümanID	Alanlar
hotels	otel_<id>	name, location, price, rating, amenities, images
users	<uid>	email, displayName, favorites
favorites	<uid>_<otelId>	uid, hotelId, addedAt


⸻

👥 Katkıda Bulunanlar

İsim	Rol
@ahmet	Proje lideri, Flutter mimarisi
@selin	Firebase & backend entegrasyonu
@murat	UI/UX tasarımı & test

PR göndermeden önce lütfen CONTRIBUTING.md dosyasını okuyun. ✨

⸻

📅 Yol Haritası
	•	🔔 Push bildirimleri ekle
	•	🌐 Çoklu dil (i18n)
	•	🧪 Widget & entegre testler
	•	🚀 CI/CD (GitHub Actions + Fastlane)

⸻

📜 Lisans

Bu proje MIT Lisansı ile lisanslanmıştır – ayrıntılar için LICENSE dosyasına bakın.

⸻

📫 İletişim

Projeyle ilgili sorularınız için info@hotelexplorer.app adresine e-posta gönderebilir veya GitHub Issues üzerinden yazabilirsiniz.
