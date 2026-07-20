# Penjelasan Proyek: Nutri-Guardian AR

## 1. Pendahuluan
Proyek ini adalah sebuah aplikasi edukasi gizi interaktif berbasis *Augmented Reality* (WebAR). Aplikasi ini dirancang agar dapat berjalan langsung di browser perangkat pengguna tanpa memerlukan instalasi aplikasi khusus. Pengguna cukup melakukan *scan* (pemindaian) pada gambar kartu (marker), dan aplikasi akan memunculkan model 3D makanan beserta karakter 2D pendamping yang membacakan informasi gizi secara langsung.

## 2. Library dan Framework yang Digunakan
Proyek ini dibangun menggunakan arsitektur WebAR murni dengan komponen-komponen utama berikut:

*   **A-Frame (v1.5.0):**
    Sebuah *framework web open-source* (berbasis HTML) yang dikembangkan oleh Mozilla. A-Frame digunakan sebagai fondasi utama untuk membangun dunia virtual (Scene 3D). Framework ini menangani *rendering* grafis, pencahayaan, posisi kamera, dan menampung model 3D yang ditampilkan.
*   **MindAR (v1.2.5):**
    *Library* pelacak (*tracking*) WebAR yang sangat ringan dan efisien. Dalam proyek ini, MindAR digunakan secara khusus untuk fitur **Image Tracking** (Pelacakan Gambar). MindAR bertugas mengakses kamera perangkat, mendeteksi kecocokan pola gambar dunia nyata dengan database gambar (`targets.mind`), lalu memproyeksikan elemen 3D dari A-Frame tepat di atas gambar tersebut secara *real-time*.
*   **Three.js:**
    *Library* 3D JavaScript tingkat rendah yang menjadi mesin utama penggerak grafis di balik A-Frame. Meskipun tidak dipanggil sebagai library mandiri di tag script, logika JavaScript khusus dalam proyek ini berinteraksi langsung dengan sistem matematika Three.js (seperti `THREE.Box3` dan `THREE.Vector3`). Fungsi ini dimanfaatkan secara intensif untuk menghitung kalibrasi *Center of Mass* (titik berat) dari model 3D `.glb` yang asimetris, sehingga objek dapat dirotasi secara stabil pada porosnya tanpa melenceng.
*   **Vanilla JavaScript, HTML5, dan CSS3:**
    Aplikasi ini sengaja tidak menggunakan *framework* JavaScript yang berat (seperti React atau Vue) agar proses *loading* AR tetap ringan dan responsif, terutama untuk perangkat seluler. Antarmuka (UI) layar awal, panel informasi, *overlay* karakter transparan, serta logika pemrograman kejadian (*event handling*) semuanya dibangun menggunakan pemrograman web dasar murni (*Vanilla*).

## 3. Tools dan Multimedia
*   **MindAR Compiler:**
    Tool (berbasis TensorFlow.js) yang digunakan untuk mengekstrak titik fitur (*feature points*) dari keenam gambar 2D (marker QR makanan) lalu mengkompilasinya menjadi satu file binary pelacak bernama `targets.mind`.
*   **Model 3D (.glb):**
    File aset 3D untuk 6 jenis makanan (Ayam, Nasi, Ikan, Sayur, Buah, Susu) menggunakan format GLTF Binary (`.glb`). Format standar industri modern ini mengkompres seluruh data geometri, material, dan tekstur menjadi satu file tunggal yang dioptimasi agar sangat cepat dirender di lingkungan Web.
*   **PowerShell Script (serve.ps1):**
    Script server statis lokal buatan sendiri untuk melayani aset aplikasi saat masa pengujian (*development*). Ini penting karena sistem keamanan peramban web modern mengharuskan penggunaan lingkungan *server* HTTP (bukan sekadar klik dua kali file HTML) dan memerlukan perlakuan *headers* MIME *types* yang tepat untuk bisa memuat file `.glb` dan `.mind`.

## 4. Sistem Suara (Voice Output)
Salah satu fitur dan teknik pengoptimalan unggulan dari proyek ini adalah ketiadaan kebutuhan untuk menyimpan file audio MP3/WAV pra-rekaman yang memakan memori besar. Hal ini dicapai dengan mendayagunakan **Web Speech API**:

1.  **Sintesis Teks-ke-Suara (*Text-to-Speech / TTS*):**
    Ketika modul MindAR mendeteksi dan mengunci sebuah marker, sistem mengekstrak teks deskripsi gizi makanan tersebut dari *database* kode, lalu menyerahkannya ke *Web Speech API* bawaan browser. Sistem perangkat keras (*device*) akan mengubah teks tersebut menjadi sinyal ucapan suara manusia secara instan (*real-time generation*).
2.  **Pemilihan Bahasa Dinamis (*Voice Filtering*):**
    Skrip aplikasi diprogram dengan fungsi khusus yang memindai daftar paket suara digital (sintesis) yang terpasang di HP/Sistem Operasi pengguna (seperti *engine* suara Google, Apple Siri, atau Microsoft). Kode ini secara pintar akan menyaring dan memaksa browser untuk memilih varian suara yang ber-tag pelafalan **Bahasa Indonesia** (`id-ID`, `id`) atau **Melayu** (`ms-MY`).
3.  **Kustomisasi Karakter "Nutri-Guardian":**
    Agar suara sintesis tidak terdengar monoton seperti robot dan lebih mencerminkan karakter panduan yang ceria, sinyal audio dimanipulasi dengan parameter kustom:
    *   **Pitch (1.22):** Frekuensi nada suara dinaikkan sedikit di atas batas normal agar terdengar lebih feminin, ramah, dan hangat.
    *   **Rate (1.15):** Kecepatan tempo bicara dipercepat 15% dari standar agar proses edukasi gizi terasa energik, interaktif, dan tidak membosankan.
4.  **Sinkronisasi UI Otomatis:**
    Audio ini dikaitkan erat dengan fungsi *event listener* pada antarmuka. Saat *engine* mulai bersuara (`onstart`), panel antarmuka akan memunculkan indikator karakter sedang berbicara (berserta teks). Ketika teks selesai diucapkan sepenuhnya (`onend`), sistem akan mengetahuinya secara presisi dan mereset antarmuka pengguna tanpa memerlukan fungsi perhitungan waktu (*timer/delay*) buatan yang rentan *error*.
