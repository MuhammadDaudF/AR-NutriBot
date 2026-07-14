# Nutri-Guardian AR — Panduan Menjalankan Proyek

## Cara Menjalankan (Pilih Salah Satu)

### Opsi 1: VS Code + Live Server (PALING MUDAH ✅)
1. Buka folder `project/` di VS Code
2. Install extension **"Live Server"** (by Ritwick Dey) dari Extensions Marketplace
3. Klik kanan `index.html` → **"Open with Live Server"**
4. Browser terbuka di `http://127.0.0.1:5500`

### Opsi 2: PowerShell Simple Server
Jalankan perintah ini di terminal (folder project):
```powershell
# Buka PowerShell, arahkan ke folder project:
cd "c:\Users\wtreatgamingyt\Downloads\nutri-guardian-ar-qr\project"

# Jalankan server:
powershell -ExecutionPolicy Bypass -File serve.ps1
```
Buka `http://localhost:8080` di browser.

### Opsi 3: Install Node.js lalu pakai npx
1. Download & install Node.js dari https://nodejs.org
2. Buka terminal di folder project
3. Jalankan: `npx -y serve .`

---

## ⚠️ PENTING: Compile Ulang targets.mind

Karena kartu makanan sudah diganti dengan desain baru, kamu **WAJIB** compile ulang file `targets.mind` agar dapat mendeteksi kartu dengan benar:

1. Buka: **https://hiukim.github.io/mind-ar-js-doc/tools/compile/**
2. Upload **ketujuh** file gambar kartu dari `assets/qr/` — **URUTAN HARUS PERSIS**:
   - `0-ayam.jpg` (Target index 0)
   - `1-nasi.jpg` (Target index 1)
   - `2-ikan.jpg` (Target index 2)
   - `3-daging.jpg` (Target index 3)
   - `4-sayur.jpg` (Target index 4)
   - `5-buah.jpg` (Target index 5)
   - `6-air.jpg` (Target index 6)
   
   > 💡 **PENTING:** Tarik (drag & drop) gambar satu per satu secara berurutan. Jangan pilih semua (Select All) lalu upload bersamaan, karena browser sering kali mengunggah file dengan urutan acak yang menyebabkan marker tertukar!
3. Klik **Start**, tunggu selesai.
4. Klik **Download**, simpan sebagai `targets.mind`.
5. Taruh file baru di folder `project/targets/targets.mind` (timpa file lama).

---

## 🔍 Cara Debugging Marker Tertukar

Kami telah menambahkan **Target Debugger** visual di layar AR. Saat kamu mengarahkan kamera ke kartu:
- Perhatikan tulisan di bawah layar: `🔍 Sensor: Kartu #ID (Nama Makanan)`.
- Jika kamu memindai kartu **Daging** tetapi debugger menampilkan `🔍 Sensor: Kartu #1 (Nasi)`, berarti urutan kompilasi pada file `targets.mind` kamu tidak urut.
- Solusi: Hapus file `targets.mind` lama dan ulangi langkah kompilasi di atas dengan mengunggah gambar secara berurutan satu per satu.

---

## Testing di HP
1. Pastikan HP & laptop **satu jaringan WiFi**
2. Cari IP laptop: buka CMD, ketik `ipconfig`, cari "IPv4 Address" (mis. `192.168.1.5`)
3. Di HP, buka: `http://192.168.1.5:5500` (sesuai port server)
4. Izinkan akses kamera
5. Arahkan kamera ke kartu yang sudah dicetak/ditampilkan di layar lain
6. **Putar Objek:** Kamu bisa mengusap (drag) layar HP ke kiri dan kanan untuk memutar karakter 3D dan makanan 360 derajat secara halus.
