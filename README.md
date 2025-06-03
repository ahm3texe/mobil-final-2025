# VersusHotels

*VersusHotels*, Flutter ve Dart kullanılarak geliştirilen, hem iOS hem de Android ortamında çalışan modern bir mobil otel karşılaştırma uygulamasıdır. Kullanıcılar, otelleri farklı kriterlere göre listeleyebilir, favorilere ekleyebilir, yan yana karşılaştırabilir ve ihtiyaçlarına göre en uygun seçeneği bulabilirler.

## İçindekiler

1. [Genel Bakış](#genel-bakış)  
2. [Özellikler](#özellikler)  
3. [Klasör Yapısı](#klasör-yapısı)  
4. [Kullanılan Teknolojiler](#kullanılan-teknolojiler)  
5. [Ekip ve Görev Dağılımı](#ekip-ve-görev-dağılımı)  
6. [Gelecek Planları](#gelecek-planları)  
7. [İletişim](#iletişim)

  - ![image](https://github.com/user-attachments/assets/c9406979-ab4d-4259-9cd4-5d6db9a1d748)

## Genel Bakış

VersusHotels, kullanıcıların ihtiyaç duyduğu tüm otel bilgilerini tek bir uygulamada toplar. Otelleri listeleyip:

- Favorilere ekleyebilir,  
- İki farklı oteli özellik bazında karşılaştırabilir,  
- Otel detaylarını inceleyebilir,  
- Basit bir iletişim formu aracılığıyla proje hakkında geri bildirimde bulunabilirler.

Projede başlangıçta “dummy” (geçici) kimlik doğrulama (register/login) SharedPreferences üzerinden sağlanmıştır ve ileride Supabase veya gerçek bir backend çözümüne geçirilmeye hazır altyapı mevcuttur.

## Özellikler

- **Kayıt & Giriş**  
  - Kullanıcılar e-posta ve şifre ile kayıt olabilir.  
  - Parola en az 6 karakter, 1 büyük harf, 1 rakam ve 1 özel karakter içermelidir.  
  - Giriş yapıldığında SharedPreferences’e e-posta saklanır.

- **Anasayfa & Otel Listesi**  
  - Oteller, Supabase Storage’dan çekilen bir hotels.json dosyası ile listelenir.  
  - “Detaylı Görünüm” ve “Liste Görünümü” arasında kolayca geçiş yapılabilir.  
  - Her otel için resim, isim, konum, yıldız sayısı ve fiyat bilgisi gösterilir.  

- **Favoriler Sayfası**  
  - Kullanıcı favorilere eklediği otelleri görüntüler.  
  - Favoriden çıkarma işlemi kolayca yapılabilir.

- **Otel Karşılaştırma**  
  - İki farklı oteli yan yana, “Konum”, “Fiyat/Gece”, “Oda Türü”, “Yıldız”, “Puan”, “Havuz”, “Kahvaltı”, “Wi-Fi”, “Evcil Hayvan” gibi kriterlere göre karşılaştırır.  
  - Üst kısımda her iki otelin görsellerini gösterir; altta hangi otelin daha fazla özelliğe sahip olduğu hakkında öneri metni sunar.

- **Otel Detay Sayfası**  
  - Seçilen otelin geniş görsel, tüm temel bilgileri, olanakları ve yorum puanı detaylı gösterilir.  
  - Favori / Karşılaştırma butonları ile kullanıcı hızlıca işlem yapabilir.

- **Hakkımızda & Ekip Tanıtımı**  
  - Ömer, Ahmet ve Ogün’ün fotoğrafları, rolleri ve kısa biyografileri ile “Biz Kimiz?” bölümü.

- **İletişim Formu**  
  - Ad, e-posta ve mesaj alanları olan basit bir form.  
  - “Gönder” butonuna tıklanınca cihazın e-posta uygulaması açılır (mailto).  
  - Sayfanın alt kısmında tıklanabilir e-posta ve telefon numarası.
  - 
## Kullanılan Teknolojiler

- **Flutter & Dart:** Çapraz platform mobil uygulama geliştirme.
- **Supabase:** Otel verileri için Storage ve gelecekte Authentication/Backend.
- **SharedPreferences:** Kullanıcı girişi ve ayarlar için yerel depolama.
- **Provider:** Durum yönetimi (State Management).
- **mailto:** İletişim formu için cihaz e-posta uygulaması entegrasyonu.

---

## Ekip ve Görev Dağılımı

### Ömer Faruk Pehlivan

**Görevler:**

- Uygulama mimarisini kurgulamak ve tüm sayfa akışlarını tasarlamak.
- Flutter’da tasarımın koda dökülmesi ve frontend implementasyonu.

**Kapsam:**

- `Login/Signup` akışı
- `home_page.dart`
- `custom_drawer.dart`
- Otel kartları: `hotel_card.dart`, `hotel_list_card.dart`
- Otel detay sayfası: `hotel_detail_page.dart`
- `favorites_page.dart`
- `comparison_page.dart`
- `settings_page.dart`
- `providers/compare_provider.dart`, `providers/settings_provider.dart`
- `widgets/custom_app_bar.dart`
- Genel tema düzenlemeleri (AppBar, buton, renk şeması)

---

### Ahmet Şafak Yıldırım

**Görevler:**

- Supabase’e veritabanı bağlantısını yapmak ve `hotels.json` dosyasını Storage’a yükleyip erişimini sağlamak.
- Otel verilerini JSON formatında hazırlamak (mevcut 30 otel) ve Supabase Storage yapılandırmak.
- `services/hotel_service.dart` içinde JSON’dan veya Storage’dan veri çekme işlemlerini kodlamak.
- Tüm görselleri (otel, logo) Supabase Storage’a eklemek ve erişim linklerini düzenlemek.
- `services/favorite_service.dart` (SharedPreferences tabanlı favori yönetimi) oluşturmak.

---

### Ogün Şahin

**Görevler:**

- Uygulama sayfalarının tasarımını (wireframe ve prototip) hazırlamak.
- `about_page.dart` ve `contact_page.dart` UI/UX tasarımı.
- Ekip üyelerinin avatarlarını ve “Biz Kimiz?” bölümünü düzenlemek.
- `assets/images/avatar/omer.jpeg`, `ahmet.jpeg`, `ogun.jpeg` görsellerini hazırlayıp eklemek.
- İletişim sayfasındaki formu ve tıklanabilir e-posta/telefon alanlarını tasarlamak.

---

## Gelecek Planları

- Supabase Authentication veya Firebase ile kimlik doğrulama.
- Otel rezervasyon özelliği eklenmesi.
- Kullanıcı yorumları ve puanlama sistemi.
- Harita entegrasyonu (Google Maps veya OpenStreetMap).
- Çoklu dil desteği için tam işlevsellik.

---
 

  - ![image](https://github.com/user-attachments/assets/c1651f26-70a8-46c0-ada3-ed33053c9c1c)
  - ![image](https://github.com/user-attachments/assets/f6339ee9-acf6-4af5-a3a8-723c3b3c280a)
  - *main.dart daki importlar ve projenin supabase api key bağlantısı*



