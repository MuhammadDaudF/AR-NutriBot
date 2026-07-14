# Nutri-Guardian AR — QR Real-Time (MindAR)

Prototipe WebAR: scan **QR code asli** (bisa dibaca app QR biasa) → muncul model 3D makanan
+ karakter 3D **Nutri-Guardian** (versi low-poly, dibuat mengikuti desain karakter yang kamu
kirim: baju scrub hijau, rambut abu-abu, memegang clipboard) → penjelasan gizi muncul di layar
dan dibacakan otomatis (Bahasa Indonesia, Web Speech API).

Teknologi: **MindAR** (image tracking, real-time, open source) + **A-Frame**. QR yang dipakai
adalah QR code sungguhan (menyimpan teks, bisa dipindai app QR apa pun) yang sekaligus dipakai
sebagai gambar pelacak posisi AR-nya.

---

## 1. Struktur folder

```
project/
├── index.html              ← aplikasi utama
├── README.md                ← file ini
├── assets/
│   ├── qr/                  ← 7 kartu QR (siap cetak)
│   │   ├── 0-ayam.png
│   │   ├── 1-nasi.png
│   │   ├── 2-ikan.png
│   │   ├── 3-daging.png
│   │   ├── 4-sayur.png
│   │   ├── 5-buah.png
│   │   └── 6-air.png
│   └── character/
│       └── nutri-guardian-reference.png   ← gambar karakter aslimu (referensi, tampil di layar awal)
└── targets/
    └── targets.mind          ← ⚠️ BELUM ADA, kamu perlu buat sendiri (langkah #2)
```

## 2. Buat file `targets.mind` (WAJIB, sekali saja)

MindAR butuh file `.mind` hasil kompilasi dari gambar target. Ini satu-satunya langkah yang
tidak bisa saya lakukan otomatis (butuh browser dengan GPU untuk kompilasi).

1. Buka tool resmi: **https://hiukim.github.io/mind-ar-js-doc/tools/compile/**
2. Upload **ketujuh** file di `assets/qr/` — **urutannya harus persis**:
   `0-ayam.png, 1-nasi.png, 2-ikan.png, 3-daging.png, 4-sayur.png, 5-buah.png, 6-air.png`
   (nama file sudah diberi awalan angka supaya urut otomatis kalau kamu select-all di file
   explorer).
3. Klik **Start**, tunggu proses selesai (beberapa detik–menit).
4. Klik **Download**, simpan hasilnya sebagai `targets.mind`.
5. Taruh file itu di dalam folder `targets/` (menggantikan file kosong yang ada).

> Kalau urutan upload salah, makanan yang muncul akan tertukar dengan marker lain — tinggal
> ulangi kompilasi dengan urutan yang benar.

## 3. Jalankan lewat VS Code (server lokal)

Kamera **tidak akan aktif** kalau file dibuka langsung (`file://...`) — harus lewat server lokal.
Paling gampang pakai extension **Live Server**:

1. Buka folder `project/` ini di VS Code.
2. Install extension **"Live Server"** (by Ritwick Dey) dari Extensions Marketplace.
3. Klik kanan `index.html` → **"Open with Live Server"**.
4. Browser akan terbuka otomatis di `http://127.0.0.1:5500` (atau port serupa) — ini aman untuk
   akses kamera karena dianggap "localhost".

Alternatif tanpa extension (kalau ada Node.js / Python terpasang):
```bash
# Node
npx serve .

# atau Python
python -m http.server 8000
```
lalu buka `http://localhost:5500` / `http://localhost:8000` di browser HP (pastikan HP & laptop
satu jaringan WiFi, lalu ganti `localhost` dengan IP laptop, misalnya `http://192.168.1.5:8000`).

## 4. Cara pakai

1. Cetak 7 kartu di `assets/qr/` (atau tampilkan di layar HP/tablet lain).
2. Buka `index.html` lewat server lokal di atas, di HP.
3. Tekan **"Mulai AR"**, izinkan akses kamera.
4. Arahkan kamera ke salah satu QR, jarak ±20–35 cm, di tempat terang & permukaan QR rata (tidak terlipat/mengkilap).
5. **Karakter 3D Nutri-Guardian** + model makanan akan muncul menempel pada QR, teks penjelasan gizi tampil di bawah layar sekaligus dibacakan dengan suara wanita.
6. **Rotasi 3D 360°:** Usap (drag/swipe) jari Anda di layar HP untuk memutar posisi karakter dan makanan 360 derajat secara halus dengan efek perlambatan (inertia).
7. **Debugger Target:** Pada panel penjelasan di bawah, terdapat tulisan `🔍 Sensor: Kartu #ID (Nama Makanan)`. Jika Anda memindai kartu "Daging" tetapi sensor memunculkan "Nasi", berarti file `targets.mind` Anda tertukar urutannya saat kompilasi. Anda harus melakukan kompilasi ulang dengan urutan upload yang sesuai.

## 5. Kalau mau ganti / tambah menu

Semua konten ada di `index.html`, di bagian atas `<script>`, array `FOODS`. Tiap item punya:
`key` (nama internal), `name`/`title` (label tampil), `icon` (emoji), `desc` (teks + narasi suara), dan `qr` (path gambar QR-nya). Untuk menambah item baru:
1. Generate QR baru (isi bebas, misal teks `MBG-TELUR-2026`) dan simpan di `assets/qr/`.
2. Tambahkan objek baru di array `FOODS` dengan `id` urut berikutnya (contoh: `7`).
3. Kompilasi ulang `targets.mind` dengan SEMUA gambar QR (urutan sesuai `id`), termasuk yang baru.
4. (Opsional) tambahkan bentuk 3D baru di fungsi `foodGeometry()`.

## 6. Fitur & Penjelasan Teknis Karakter 3D

- **Karakter 3D Beranimasi:** Karakter Nutri-Guardian dibangun sebagai model 3D utuh berbasis *A-Frame Primitives* (rendah poligon/low-poly). Ini menghindari penggunaan file `.gltf`/`.glb` eksternal yang besar dan lambat dimuat di HP.
- **Gerakan Interaktif:** Karakter memiliki animasi idle (bernapas dan mengayun lembut) dan animasi berbicara (mulut bergerak terbuka/tertutup, kepala mengangguk, tangan kanan melambai/menunjuk) yang secara otomatis tersinkronisasi ketika suara penjelasan dimulai dan selesai.
- **Suara Perempuan:** Web Speech API dikonfigurasi untuk memindai suara bawaan perangkat Anda dan memprioritaskan suara wanita berbahasa Indonesia/Melayu (seperti Microsoft Gadis, Apple Dina/Damayanti, atau Google Bahasa Indonesia) dengan penyesuaian pitch tinggi (1.22) agar terdengar ramah dan feminin.

---

Jika ada error saat dicoba (marker tidak terbaca, karakter tidak muncul, dll), silakan kirimkan pesan error di console browser Anda.
