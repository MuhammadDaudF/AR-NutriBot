# Nutri-Guardian AR — QR Real-Time (MindAR)

Aplikasi WebAR edukasi gizi interaktif. Scan **QR code / Gambar Marker** → muncul model 3D makanan (format `.glb`). 
Karakter 2D **Nutri-Guardian** akan muncul di layar HUD dan membacakan penjelasan gizi secara otomatis (menggunakan Web Speech API).

Teknologi: **MindAR** (image tracking, real-time, open source) + **A-Frame**.

---

## 1. Struktur Folder

```text
project/
├── index.html              ← Aplikasi utama WebAR
├── README.md               ← File panduan ini
├── serve.ps1               ← Script server lokal PowerShell
├── assets/
│   ├── models/             ← File 3D (.glb) makanan (ayam, nasi, ikan, sayur, buah, susu)
│   ├── qr/                 ← 6 pasang gambar QR/Marker (siap cetak & ditracking)
│   │   ├── 1-ayam.png
│   │   ├── 2-nasi.png
│   │   ├── 3-ikan.png
│   │   ├── 4-sayur.png
│   │   ├── 5-buah.png
│   │   └── 6-susu.png
│   └── character/
│       └── nutri-guardian-reference.png   ← Gambar karakter (overlay transparan di layar)
└── targets/
    └── targets.mind        ← File tracking utama hasil compile dari gambar-gambar QR
```

## 2. Buat / Update file `targets.mind` (WAJIB JIKA GAMBAR MARKER DIGANTI)

Jika Anda mengganti gambar di folder `assets/qr/`, kamera **TIDAK AKAN** mengenalinya secara otomatis. Anda WAJIB meng-compile ulang (membuat) file `targets.mind` baru.

1. Buka website compiler resmi MindAR: **https://hiukim.github.io/mind-ar-js-doc/tools/compile/**
2. Klik tombol Drop/Upload images.
3. Pilih **keenam** gambar marker Anda dari folder `assets/qr/`. **SANGAT PENTING: Anda harus memilih dengan URUTAN yang persis sama seperti ini**:
   1. `1-ayam.png`
   2. `2-nasi.png`
   3. `3-ikan.png`
   4. `4-sayur.png`
   5. `5-buah.png`
   6. `6-susu.png`
   *(Nama file sudah diberi angka di depan agar mudah diurutkan).*
4. Klik **Start**, tunggu proses loading selesai.
5. Setelah beres, klik **Download** (akan menghasilkan file `targets.mind`).
6. Pindahkan file tersebut ke dalam folder `targets/` project ini (tumpuk file yang lama).

## 3. Menjalankan Server Lokal (Untuk Uji Coba)

Kamera AR **tidak akan aktif** jika file `index.html` hanya dibuka secara langsung (lewat *File Explorer*). Anda harus membukanya melalui server lokal!

**Pilihan 1: Menggunakan Script (Paling Disarankan)**
1. Di Windows, klik kanan pada file `serve.ps1` -> **Run with PowerShell**.
2. Biarkan jendela biru tetap terbuka.
3. Buka browser (di laptop Anda) dan ketik: `http://localhost:3000`

**Pilihan 2: Menggunakan Live Server di VS Code**
1. Install extension **"Live Server"** di VS Code.
2. Buka file `index.html`, klik kanan -> **Open with Live Server**.

**Penting Jika Mengetes Lewat HP (WiFi yang sama):**
Browser HP (Chrome/Safari) akan otomatis memblokir akses Kamera jika Anda mengakses via IP Address tanpa koneksi HTTPS (SSL). Solusinya:
- **Di Chrome Android:** Ketik `chrome://flags` di URL bar, cari **"Insecure origins treated as secure"**, ketikkan IP address komputer Anda beserta port-nya (misal: `http://192.168.1.5:3000`), klik Enable, lalu tekan Relaunch browser.

## 4. Cara Penggunaan AR

1. Cetak 6 gambar dari folder `assets/qr/` atau cukup tampilkan di layar HP/tablet/laptop lain.
2. Buka `index.html` (lewat server lokal) dari browser Anda.
3. Tekan **"Mulai AR"**, dan klik Izinkan (Allow) Akses Kamera.
4. Arahkan kamera ke salah satu gambar target (jarak ideal ±20–35 cm, pencahayaan cukup).
5. **Model 3D Makanan** akan langsung *pop-up* (muncul) tepat di atas gambar target tersebut.
6. Penjelasan gizi akan muncul di panel bawah layar dan otomatis dibacakan oleh suara narator *Nutri-Guardian*.
7. **Interaksi Objek:** Anda dapat mengusap/drag layar untuk merotasi objek makanan 360 derajat secara manual.

## 5. Fitur Utama & Optimasi Terkini

- **Custom 3D Models (`.glb`):** Aplikasi ini menggunakan aset 3D *custom* buatan sendiri. Skala objek di dalam scene telah dioptimalkan (diperbesar 3x lipat) agar lebih pas dengan besaran kartu.
- **Center of Mass Calibration:** Model-model 3D telah direkalibrasi *pivot origin*-nya sehingga objek 3D dapat berputar dan dirotasi pengguna dengan stabil, presisi persis pada poros pusatnya (tidak mengorbit aneh).
- **1-Euro Filter Stabilizer:** Parameter algoritma AR Camera telah diperketat (`filterMinCF`, `filterBeta`) agar proyeksi 3D tidak bergetar (anti-jittering) sekalipun tangan Anda sedikit bergoyang saat memegang kartu.
- **Suara Bahasa Indonesia Dinamis:** Memakai *Web Speech API* yang mendeteksi bahasa OS secara dinamis dan dikonfigurasi menggunakan *pitch* yang disesuaikan untuk menghasilkan suara narator wanita digital yang interaktif. 

---
**Catatan Error AR:**
Jika saat memuat halaman muncul peringatan *"AR Error: Gagal mengakses kamera ATAU file targets.mind bermasalah"*, periksa kembali apakah izin akses kamera di browser Anda ditolak, ATAU pastikan file `targets.mind` sudah dicompile ulang dengan jumlah total gambar marker yang tepat.
