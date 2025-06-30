import 'package:flutter/material.dart';

class DepoDetailPage extends StatelessWidget {
  final String title;
  final String detailImagePath;
  final String description;
  final String employeeCount;
  final String equipmentDescription;
  final String capabilities;
  final String loko;
  final String? rescueTrain; // nullable


  const DepoDetailPage({
    super.key,
    required this.title,
    required this.detailImagePath,
    required this.description,
    required this.employeeCount,
    required this.equipmentDescription,
    required this.capabilities,
    required this.loko,
    this.rescueTrain,
  });

  Widget _InfoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.deepPurple, size: 30),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 14.5,
                      color: Colors.black87,
                      height: 1.4,
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
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8A2387), Color(0xFFE94057)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Text(title),
          backgroundColor: Colors.transparent,
          elevation: 2,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Gambar peta depo
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

            // Konten utama
            Container(
              transform: Matrix4.translationValues(0, -30, 0),
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
                  // Judul depo
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Deskripsi
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Judul bagian Sarana Prasarana
                  const Text(
                    'SARANA',
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Kartu info
                  _InfoCard(
                    icon: Icons.people,
                    title: 'Jumlah Pegawai',
                    content: '$employeeCount Orang',
                  ),
                  _InfoCard(
                    icon: Icons.factory,
                    title: 'Fasilitas Utama',
                    content: equipmentDescription,
                  ),
                  _InfoCard(
                    icon: Icons.home_repair_service_sharp,
                    title: 'Kemampuan Depo',
                    content: capabilities,
                  ),
                  _InfoCard(
                    icon: Icons.train_outlined,
                    title: 'Armada yang Tersedia',
                    content: loko,
                  ),
                  if (rescueTrain != null && rescueTrain!.isNotEmpty)
                  _InfoCard(
                    icon: Icons.fire_truck_outlined,
                    title: 'Rescue Train',
                    content: rescueTrain!,
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
