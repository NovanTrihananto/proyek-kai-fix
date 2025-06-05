import 'package:flutter/material.dart';

class DepoDetailPage extends StatelessWidget {
  final String title;
  final String detailImagePath; // Ganti menjadi detailImagePath
  final String description;
  final String employeeCount;
  final String equipmentDescription;
  final String capabilities;

  const DepoDetailPage({
    super.key,
    required this.title,
    required this.detailImagePath, // Perbarui konstruktor
    required this.description,
    required this.employeeCount,
    required this.equipmentDescription,
    required this.capabilities,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.deepPurple),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Depo (sekarang menggunakan detailImagePath)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  detailImagePath, // <-- Menggunakan detailImagePath
                  height: 350,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),

              // Deskripsi singkat
              Text(description, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),

              // ... (bagian Jumlah Pegawai & Deskripsi Alat dan Kemampuan Depo tidak berubah)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.deepPurple),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Jumlah Pegawai',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(employeeCount),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.deepPurple),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Deskripsi Alat',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(equipmentDescription),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.deepPurple),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kemampuan Depo',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(capabilities),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
