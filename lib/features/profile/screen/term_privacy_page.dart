import 'package:flutter/material.dart';
import '../../../core/theme/app_color.dart';

class TermsPrivacyPage extends StatelessWidget {
  const TermsPrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Terms & Privacy Policy",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.shade200,
            ),
          ),
          child: const Text(
            """
Eventra adalah aplikasi yang dirancang untuk membantu pengguna menemukan dan memperoleh informasi mengenai event, booth, produk, jadwal, serta informasi pendukung lainnya selama berada di suatu event.

Eventra juga sedang dikembangkan dengan fitur pengelolaan booth yang memungkinkan pengelola booth mengatur informasi seperti status booth, ketersediaan produk, serta informasi antrean.

Kebijakan Privasi ini menjelaskan bagaimana Eventra menangani informasi pengguna dalam versi aplikasi yang sedang dikembangkan.

1. Informasi yang Kami Kumpulkan

Informasi yang dikumpulkan Eventra bergantung pada fitur yang digunakan pengguna.

     1.1 Informasi Akun

Apabila pengguna membuat akun Eventra, kami dapat memproses informasi yang diperlukan untuk membuat dan mengelola akun, seperti:

* Alamat email.
* Identitas akun pengguna.
* Informasi profil yang diberikan oleh pengguna.
* Informasi autentikasi yang diperlukan untuk mengakses akun.

Kami hanya menggunakan informasi tersebut untuk menyediakan dan mengelola layanan Eventra.

     1.2 Informasi Event dan Booth

Ketika menggunakan fitur event dan booth, Eventra dapat memproses informasi seperti:

* Event yang dipilih atau diikuti.
* Informasi booth.
* Nama dan kategori booth.
* Deskripsi booth.
* Foto booth atau produk.
* Informasi menu.
* Harga produk.
* Status buka atau tutup booth.
* Informasi ketersediaan produk.
* Informasi antrean dan estimasi waktu tunggu.

Informasi mengenai booth dapat ditampilkan kepada pengguna lain karena informasi tersebut merupakan bagian dari fungsi utama Eventra sebagai aplikasi navigasi dan informasi event.

     1.3 Informasi Pesanan

Apabila pengguna melakukan proses pemesanan tiket, Eventra dapat memproses:

* Identitas pesanan.
* Event yang dipesan.
* Jenis tiket.
* Jumlah tiket.
* Harga tiket.
* Total pesanan.
* Status pembayaran.

Informasi tersebut digunakan untuk membuat dan mengelola pesanan pengguna.

---

2. Pembayaran

Eventra saat ini menggunakan *Midtrans Sandbox* untuk keperluan pengembangan, pengujian, dan demonstrasi sistem pembayaran.

Dengan demikian, transaksi pembayaran pada versi aplikasi saat ini *bukan transaksi pembayaran produksi yang sebenarnya*.

Fitur pembayaran Sandbox digunakan untuk menguji alur seperti:

1. Pembuatan pesanan.
2. Pembuatan transaksi pembayaran.
3. Pemilihan metode pembayaran.
4. Perubahan status pembayaran.
5. Verifikasi status transaksi.
6. Penyelesaian alur pembayaran.

Eventra dapat menerima informasi transaksi yang diperlukan untuk mengetahui status pesanan, seperti:

* ID pesanan.
* ID transaksi.
* Metode pembayaran.
* Status transaksi.
* Informasi yang diperlukan untuk mencocokkan transaksi dengan pesanan.

Eventra tidak bermaksud menyimpan informasi kartu pembayaran, PIN, password pembayaran, atau kredensial pembayaran sensitif pengguna.

Informasi pembayaran yang diproses melalui Midtrans dapat tunduk pada kebijakan dan ketentuan privasi Midtrans.

*Pada saat Eventra menggunakan sistem pembayaran produksi, kebijakan ini dapat diperbarui untuk menjelaskan perubahan tersebut.*

---

3. Informasi Lokasi

Eventra dapat menggunakan informasi lokasi perangkat apabila pengguna memberikan izin lokasi dan fitur tersebut digunakan.

Informasi lokasi dapat digunakan untuk membantu:

* Menampilkan posisi pengguna.
* Menampilkan event atau booth di sekitar pengguna.
* Membantu pengguna menemukan lokasi booth.
* Menyediakan fitur navigasi menuju booth atau lokasi event.

Pengguna dapat mengaktifkan atau menonaktifkan izin lokasi melalui pengaturan perangkat.

Eventra tidak menggunakan lokasi pengguna untuk tujuan yang tidak berkaitan dengan fungsi lokasi aplikasi.

4. Fitur yang Belum Tersedia

Eventra masih berada dalam tahap pengembangan. Oleh karena itu, beberapa fitur yang direncanakan belum tersedia pada versi aplikasi saat ini.

      4.1 Fitur Chat

Fitur chat atau komunikasi antar pengguna/pengelola booth *belum tersedia* pada versi aplikasi saat ini.

Karena fitur tersebut belum tersedia, Eventra saat ini tidak mengumpulkan atau memproses isi percakapan melalui fitur chat.

Apabila fitur chat tersedia di masa mendatang, Kebijakan Privasi ini dapat diperbarui untuk menjelaskan jenis data yang diproses dan bagaimana data tersebut digunakan.

     4.2 Fitur Artificial Intelligence (AI)

Fitur berbasis Artificial Intelligence (AI) *belum tersedia* pada versi aplikasi saat ini.

Eventra saat ini tidak mengirimkan percakapan, pertanyaan, atau konten pengguna kepada layanan AI untuk fitur tersebut.

Apabila fitur AI ditambahkan di masa mendatang, Eventra akan memperbarui Kebijakan Privasi ini untuk menjelaskan:

* Data yang dikirim ke layanan AI.
* Tujuan pemrosesan.
* Penyedia layanan AI yang digunakan.
* Cara data disimpan dan diproses.

5. Penggunaan Informasi

Informasi pengguna yang dikumpulkan pada versi Eventra saat ini dapat digunakan untuk:

* Membuat dan mengelola akun.
* Menyediakan informasi event.
* Menampilkan informasi booth.
* Menampilkan menu dan harga.
* Mengelola pesanan tiket.
* Mengelola status pembayaran Sandbox.
* Menyediakan fitur navigasi.
* Menampilkan informasi antrean dan estimasi waktu tunggu.
* Menampilkan informasi ketersediaan produk.
* Menjaga keamanan aplikasi.
* Mendeteksi dan memperbaiki masalah teknis.
* Meningkatkan kualitas dan pengalaman penggunaan Eventra.

Eventra tidak menjual informasi pribadi pengguna kepada pihak lain.

6. Data Booth

Pengguna yang memiliki akses sebagai pengelola booth dapat memasukkan informasi yang berkaitan dengan booth mereka.

Informasi tersebut dapat meliputi:

* Nama booth.
* Deskripsi.
* Kategori.
* Foto.
* Menu.
* Harga.
* Status booth.
* Informasi stok atau ketersediaan.
* Estimasi antrean.
* Estimasi waktu tunggu.

Informasi booth yang ditujukan untuk pengunjung dapat ditampilkan kepada pengguna Eventra lainnya.

Pengelola booth bertanggung jawab untuk memastikan bahwa informasi yang mereka masukkan tidak melanggar hak atau privasi pihak lain.

7. Layanan Pihak Ketiga

Eventra dapat menggunakan layanan pihak ketiga untuk mendukung fungsi aplikasi.

Pada versi pengembangan saat ini, layanan tersebut dapat mencakup:

* *Supabase* untuk autentikasi, database, dan layanan backend.
* *Midtrans Sandbox* untuk pengujian alur pembayaran.
* *Open Street Map atau layanan peta terkait* untuk kebutuhan lokasi dan navigasi, apabila digunakan oleh versi aplikasi.

Pihak ketiga tersebut dapat memproses informasi sesuai dengan kebutuhan layanan mereka dan kebijakan privasi masing-masing.

Eventra tidak mengendalikan kebijakan privasi pihak ketiga dan pengguna disarankan untuk membaca kebijakan mereka apabila diperlukan.

8. Keamanan Informasi

Eventra berupaya menerapkan langkah keamanan yang wajar untuk melindungi informasi pengguna dari akses, penggunaan, perubahan, atau pengungkapan yang tidak sah.

Langkah tersebut dapat mencakup:

* Autentikasi akun.
* Pengendalian akses.
* Penggunaan koneksi HTTPS.
* Pengamanan kredensial server.
* Pembatasan akses terhadap data sensitif.
* Penggunaan layanan infrastruktur yang menyediakan mekanisme keamanan.

Meskipun demikian, tidak ada sistem elektronik yang dapat menjamin keamanan data secara mutlak.

9. Penyimpanan Data

Data dapat disimpan selama diperlukan untuk:

* Menyediakan layanan Eventra.
* Mengelola akun pengguna.
* Mengelola pesanan.
* Menyimpan informasi booth.
* Menyelesaikan proses pengujian sistem.
* Memenuhi kebutuhan keamanan dan teknis.

Ketika data tidak lagi diperlukan, Eventra dapat menghapus atau menganonimkan data tersebut sesuai dengan kebutuhan dan ketentuan yang berlaku.

10. Penghapusan Akun dan Data

Pengguna dapat mengajukan permintaan untuk menghapus akun dan data pribadi yang berkaitan dengan akun tersebut.

Permintaan dapat dilakukan melalui:

*Email:* jamiehardiwijaya@student.upi.edu

Eventra akan memproses permintaan tersebut sesuai dengan kebijakan penyimpanan data dan ketentuan hukum yang berlaku.

Data tertentu dapat tetap disimpan apabila diperlukan untuk memenuhi kewajiban hukum, keamanan, penyelesaian sengketa, atau kebutuhan lain yang diperbolehkan oleh hukum.

11. Hak Pengguna

Pengguna dapat memiliki hak tertentu atas data pribadi mereka sesuai dengan peraturan perlindungan data yang berlaku.

Hak tersebut dapat mencakup:

* Memperoleh informasi mengenai penggunaan data pribadi.
* Mengakses data pribadi.
* Memperbaiki data yang tidak akurat.
* Meminta penghapusan data sesuai ketentuan yang berlaku.
* Menarik persetujuan apabila pemrosesan didasarkan pada persetujuan.
* Mengajukan pertanyaan atau keluhan terkait pemrosesan data.

Untuk menggunakan hak tersebut, pengguna dapat menghubungi Eventra melalui kontak yang tersedia dalam kebijakan ini.

12. Data Anak

Eventra tidak secara khusus ditujukan sebagai layanan untuk anak-anak.

Kami tidak dengan sengaja meminta informasi pribadi anak yang tidak diperlukan untuk menjalankan layanan.

Apabila orang tua atau wali mengetahui bahwa seorang anak memberikan data pribadi kepada Eventra secara tidak semestinya, orang tua atau wali dapat menghubungi kami untuk meminta peninjauan.

13. Perubahan Kebijakan Privasi

Eventra dapat memperbarui Kebijakan Privasi ini apabila:

* Fitur baru ditambahkan.
* Fitur yang ada mengalami perubahan.
* Penyedia layanan pihak ketiga berubah.
* Cara pemrosesan data berubah.
* Terdapat perubahan peraturan yang relevan.

Apabila terdapat perubahan penting, Eventra akan berupaya memberikan pemberitahuan melalui aplikasi atau sarana komunikasi yang sesuai.

Tanggal pembaruan terbaru akan dicantumkan pada bagian atas dokumen.

14. Hubungi Kami

Apabila pengguna memiliki pertanyaan, permintaan, atau keluhan mengenai privasi dan penggunaan data pribadi, pengguna dapat menghubungi:

Email: jamiehardiwijaya@student.upi.edu

15. Kepatuhan terhadap Peraturan

Eventra berupaya menangani data pribadi dengan memperhatikan ketentuan perlindungan data yang berlaku di Indonesia, termasuk *Undang-Undang Republik Indonesia Nomor 27 Tahun 2022 tentang Pelindungan Data Pribadi (UU PDP)* dan ketentuan lain yang relevan.


Status Fitur Eventra Saat Ini

Untuk transparansi, Eventra saat ini berada dalam tahap pengembangan dan tidak semua fitur yang direncanakan telah tersedia.
""",
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
