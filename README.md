# VersusHotels

*VersusHotels*, Flutter ve Dart kullanılarak geliştirilen, hem iOS hem de Android ortamında çalışan modern bir mobil otel karşılaştırma uygulamasıdır. Kullanıcılar, otelleri farklı kriterlere göre listeleyebilir, favorilere ekleyebilir, yan yana karşılaştırabilir ve ihtiyaçlarına göre en uygun seçeneği bulabilirler.

## İçindekiler

1. [Genel Bakış](#genel-bakış)  
2. [Özellikler](#özellikler)  
3. [Kurulum ve Çalıştırma](#kurulum-ve-çalıştırma)  
4. [Klasör Yapısı](#klasör-yapısı)  
5. [Kullanılan Teknolojiler](#kullanılan-teknolojiler)  
6. [Ekip ve Görev Dağılımı](#ekip-ve-görev-dağılımı)  
7. [Gelecek Planları](#gelecek-planları)  
8. [İletişim](#iletişim)

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
