import 'package:flutter/material.dart';
import '../constants/colors.dart';

class PanduanScreen extends StatelessWidget {
  const PanduanScreen({super.key});

  final List<Map<String, dynamic>> panduanLangkah = const [
    {
      'icon': Icons.login,
      'title': 'Login',
      'desc': 'Masukkan username dan instansi Anda di halaman login.',
    },
    {
      'icon': Icons.dashboard,
      'title': 'Dashboard',
      'desc': 'Setelah login, Anda akan diarahkan ke dashboard utama.',
    },
    {
      'icon': Icons.help_outline,
      'title': 'Panduan',
      'desc': 'Menu ini berisi petunjuk penggunaan aplikasi.',
    },
    {
      'icon': Icons.school,
      'title': 'Edukasi',
      'desc':
          'Pelajari materi edukasi yang tersedia untuk memperdalam pengetahuan Anda.',
    },
    {
      'icon': Icons.qr_code_scanner,
      'title': 'Noisense',
      'desc': 'Gunakan menu Noisense untuk scan QR lokasi.',
    },
    {
      'icon': Icons.feedback,
      'title': 'Feedback',
      'desc': 'Kirim saran atau kritik melalui menu Feedback.',
    },
    {
      'icon': Icons.login,
      'title': 'Login',
      'desc': 'Masukkan username dan instansi Anda di halaman login.',
    },
    {
      'icon': Icons.dashboard,
      'title': 'Dashboard',
      'desc': 'Setelah login, Anda akan diarahkan ke dashboard utama.',
    },
    {
      'icon': Icons.business,
      'title': 'Informasi Depo',
      'desc': 'Informasi fasilitas yang tersedia dapat diakses di sini.',
    },
    {
      'icon': Icons.logout,
      'title': 'Logout',
      'desc': 'Gunakan tombol Logout untuk keluar dari aplikasi.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panduan Penggunaan'),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            color: AppColors.primary.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.waving_hand, color: AppColors.primary, size: 30),
                    const SizedBox(width: 12),
                    Text(
                      'Selamat datang!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        shadows: [
                          Shadow(
                            blurRadius: 3,
                            color: AppColors.primary.withOpacity(0.3),
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Berikut ini adalah langkah-langkah untuk menggunakan aplikasi dengan baik dan benar.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: panduanLangkah.length,
              itemBuilder: (context, index) {
                final langkah = panduanLangkah[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.15),
                      child: Icon(langkah['icon'], color: AppColors.primary),
                    ),
                    title: Text(
                      langkah['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: AppColors.primary,
                      ),
                    ),
                    subtitle: Text(
                      langkah['desc'],
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
