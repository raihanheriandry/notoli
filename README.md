# Notoli - Write Easily 📝

**Notoli** adalah aplikasi catatan (note-taking) berbasis Flutter yang dirancang untuk kecepatan, kemudahan penggunaan, dan privasi penuh. Dengan fokus pada pengalaman **offline-first**, Notoli memastikan semua data Anda tetap aman di perangkat menggunakan enkripsi dan database lokal yang efisien.

## ✨ Fitur Utama

* **Offline Storage:** Menggunakan SQLite (`sqflite`) untuk penyimpanan data lokal yang cepat dan andal.
* **Rich Text Editing:** Menulis catatan lebih ekspresif dengan dukungan `flutter_quill`.
* **Staggered Layout:** Tampilan catatan yang dinamis dan estetik.
* **Smooth Animations:** Transisi antar halaman dan elemen UI yang halus berkat `flutter_animate` dan `animations`.
* **Multimedia Support:** Lampirkan gambar atau file langsung ke dalam catatan Anda.
* **Privacy & Security:** Keamanan tambahan menggunakan hashing `crypto` dan penyimpanan preferensi pengguna yang aman.
* **Smart Search & Export:** Temukan catatan dengan mudah dan bagikan ke platform lain menggunakan `share_plus`.

---

## 🛠️ Teknologi & Dependensi

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![SQLite](https://img.shields.io/badge/sqlite-%2307405e.svg?style=for-the-badge&logo=sqlite&logoColor=white)

Proyek ini dibangun menggunakan **Flutter SDK** dengan library utama sebagai berikut:

| Kategori | Package | Kegunaan |
| --- | --- | --- |
| **Database** | `sqflite`, `path` | Manajemen database SQL lokal |
| **State Management** | `provider` | Pengaturan state aplikasi yang efisien |
| **UI/UX** | `flutter_animate`, `animations` | Animasi dan transisi modern |
| **Editor** | `flutter_quill` | Editor teks kaya (Rich Text Editor) |
| **Storage** | `shared_preferences` | Menyimpan setting/konfigurasi user |
| **Utilities** | `intl`, `uuid`, `timezone` | Formatting waktu, ID unik, dan zona waktu |
| **Media** | `image_picker`, `file_picker` | Mengambil gambar dan file dari galeri |

---

## 🚀 Cara Memulai

### Prasyarat

* Flutter SDK (Versi terbaru disarankan)
* Android Studio / VS Code
* Emulator atau perangkat fisik Android/iOS

### Instalasi

1. **Clone repositori:**
```bash
git clone https://github.com/username/notoli.git
cd notoli
```

2. **Install dependensi:**
```bash
flutter pub get
```

3. **Jalankan aplikasi:**
```bash
flutter run
```


---

## 📁 Struktur Folder Utama

```text
lib/
├── db/            # Database helper (SQFlite konfigurasi & migrasi)
├── models/        # Model data
├── providers/     # State management (Provider) untuk koordinasi UI & Data
├── repository/    # Abstraksi data (penghubung antara DB Helper dan Provider)
├── pages/         # Layar utama aplikasi (Screens)
├── theme/         # Konfigurasi tema (Warna, Tipografi, Dark Mode)
├── util/          # Fungsi pembantu
├── widgets/       # Komponen UI yang reusable
└── main.dart
```

---

## 🔒 Keamanan & Privasi

Notoli sangat menghargai privasi Anda:

* **Tanpa Cloud:** Data tidak pernah meninggalkan perangkat Anda kecuali Anda membagikannya secara manual.
* **Integritas Data:** Menggunakan `crypto` untuk memastikan validitas data sensitif jika diperlukan.

---
