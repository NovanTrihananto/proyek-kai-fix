import 'package:flutter/material.dart';

class DepoDetailPage extends StatelessWidget {
  final String title;
  final String detailImagePath;
  final String description;
  final String employeeCount;
  final String equipmentDescription;
  final String capabilities;
  final String loko;

  const DepoDetailPage({
    super.key,
    required this.title,
    required this.detailImagePath,
    required this.description,
    required this.employeeCount,
    required this.equipmentDescription,
    required this.capabilities,
    required this.loko,
  });

  // Fungsi card yang fleksibel tanpa shadow
  Widget _InfoCard({
    IconData? icon,
    required String title,
    required String content,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.deepPurple, size: 28),
              const SizedBox(width: 14),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title.isNotEmpty)
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                  if (title.isNotEmpty) const SizedBox(height: 6),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade800,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.deepPurple,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar utama
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: Image.asset(
                detailImagePath,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),

            // Kartu isi
            Container(
              transform: Matrix4.translationValues(0, -20, 0),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Deskripsi singkat tanpa ikon
                  Text(
                    'Deskripsi Singkat',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InfoCard(
                    icon: null,
                    title: '',
                    content: description,
                  ),
                  const SizedBox(height: 12),

                  // Info lainnya
                  _InfoCard(
                    icon: Icons.stars,
                    title: '',
                    content: 'Jumlah pegawai: $employeeCount',
                  ),
                  _InfoCard(
                    icon: Icons.build,
                    title: '',
                    content: 'Fasilitas utama: $equipmentDescription',
                  ),
                  _InfoCard(
                    icon: Icons.settings,
                    title: '',
                    content: 'Kemampuan depo: $capabilities',
                  ),
                  _InfoCard(
                    icon: Icons.train,
                    title: '',
                    content: 'Armada yang tersedia: $loko',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
