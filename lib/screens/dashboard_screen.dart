import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../routes.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import 'fitur/sarana_screen.dart'; // Impor DepoDetailPage yang sudah diperbaiki
import '../models/depo_model.dart'; // Impor DepotModel

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AuthService _authService = AuthService();
  UserModel? _currentUser;
  bool _isLoading = true;

  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Definisikan data depo Anda di sini dengan dua jalur gambar berbeda
  final List<DepoModel> _depots = [
    DepoModel(
      title: 'Depo Lokomotif Yogyakarta',
      thumbnailImagePath: 'assets/images/lokoj.jpg', // Gambar untuk thumbnail
      detailImagePath: 'assets/maps/lokoy.png', // Gambar berbeda untuk halaman detail
      description:
          'Depo Lokomotif Yogyakarta merupakan fasilitas pemeliharaan dan perawatan lokomotif yang mendukung operasional kereta api di wilayah Yogyakarta.',
      employeeCount: '45 orang',
      equipmentDescription:
          'Terdapat peralatan untuk perawatan lokomotif seperti mesin las, lifting jack, dan alat ukur tekanan.',
      capabilities:
          'Depo ini mampu melakukan perawatan rutin, perbaikan kerusakan ringan hingga sedang, serta inspeksi keselamatan berkala terhadap lokomotif.',
    ),
    DepoModel(
      title: 'Depo Lokomotif Solo Balapan',
      thumbnailImagePath: 'assets/images/lokos.jpg',
      detailImagePath: 'assets/maps/lokos.png', // Gambar detail yang berbeda
      description:
          'Depo Lokomotif Solo Balapan merupakan fasilitas pemeliharaan dan perawatan lokomotif yang mendukung operasional kereta api di wilayah Solo.',
      employeeCount: '40 orang',
      equipmentDescription:
          'Dilengkapi dengan fasilitas perbaikan engine, sistem kelistrikan, dan bogie lokomotif.',
      capabilities:
          'Depo ini memiliki kemampuan untuk overhaul lokomotif, perbaikan kerusakan berat, dan pengujian performa mesin.',
    ),
    DepoModel(
      title: 'Depo Kereta Yogyakarta',
      thumbnailImagePath: 'assets/images/keretaj.png',
      detailImagePath: 'assets/maps/keretay.png', // Gambar detail yang berbeda
      description:
          'Depo Kereta Yogyakarta merupakan fasilitas pemeliharaan dan perawatan kereta penumpang yang mendukung operasional kereta api di wilayah Yogyakarta.',
      employeeCount: '55 orang',
      equipmentDescription:
          'Terdapat berbagai peralatan untuk perawatan interior, AC, sistem pintu, dan sistem kelistrikan kereta penumpang.',
      capabilities:
          'Depo ini mampu melakukan perawatan harian, bulanan, hingga tahunan untuk kereta penumpang, serta perbaikan kerusakan major.',
    ),
    DepoModel(
      title: 'Depo Kereta Solo Balapan',
      thumbnailImagePath: 'assets/images/keretas.jpeg',
      detailImagePath: 'assets/maps/keretas.png', // Gambar detail yang berbeda
      description:
          'Depo Kereta Solo Balapan merupakan fasilitas pemeliharaan dan perawatan kereta penumpang yang mendukung operasional kereta api di wilayah Solo.',
      employeeCount: '38 orang',
      equipmentDescription:
          'Fasilitas mencakup area pencucian otomatis, perbaikan sistem penerangan, dan pengecekan roda kereta.',
      capabilities:
          'Melayani inspeksi rutin, perbaikan minor, dan persiapan kereta sebelum keberangkatan untuk rute jarak dekat.',
    ),
    DepoModel(
      title: 'Depo Gerbong Rewulu',
      thumbnailImagePath: 'assets/images/rewulu.JPG',
      detailImagePath: 'assets/maps/rewulu.png', // Gambar detail yang berbeda
      description:
          'Depo Gerbong Rewulu merupakan pusat perawatan dan perbaikan gerbong barang yang vital untuk distribusi logistik kereta api.',
      employeeCount: '60 orang',
      equipmentDescription:
          'Dilengkapi dengan crane berkapasitas besar, alat press roda, dan area khusus untuk perbaikan sasis gerbong.',
      capabilities:
          'Depo ini mampu melakukan perbaikan struktur gerbong, penggantian roda, dan pengujian beban untuk berbagai jenis gerbong barang.',
    ),
    DepoModel(
      title: 'Depo PUK Yogyakarta',
      thumbnailImagePath: 'assets/images/puk.JPG',
      detailImagePath: 'assets/maps/puky.png', // Gambar detail yang berbeda
      description:
          'Depo PUK (Perawatan Unit Khusus) Yogyakarta menangani perawatan dan perbaikan unit khusus perkeretaapian, seperti kereta inspeksi, kereta derek, dan alat berat rel.',
      employeeCount: '30 orang',
      equipmentDescription:
          'Spesialisasi pada alat diagnostik elektronik, perbaikan sistem hidrolik, dan komponen presisi untuk unit khusus.',
      capabilities:
          'Fokus pada perawatan preventif dan korektif untuk memastikan kesiapan operasional unit khusus dalam mendukung infrastruktur dan keselamatan perkeretaapian.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final user = await _authService.getCurrentUser();
    setState(() {
      _currentUser = user;
      _isLoading = false;
    });
  }

  Widget buildMenuButton(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primary,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  // Fungsi tunggal untuk membangun kartu depo
  Widget _buildDepoCard(DepoModel depot) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke DepoDetailPage, meneruskan seluruh objek DepotModel
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DepoDetailPage(
              title: depot.title,
              detailImagePath: depot.detailImagePath, // <-- Meneruskan detailImagePath
              description: depot.description,
              employeeCount: depot.employeeCount,
              equipmentDescription: depot.equipmentDescription,
              capabilities: depot.capabilities,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(depot.thumbnailImagePath), // <-- Menggunakan thumbnailImagePath
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(12),
        child: Text(
          depot.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8A2387), Color(0xFFE94057)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          Routes.profile,
                        );
                        if (result == 'updated') {
                          _loadUserData();
                        }
                      },
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 24,
                            backgroundImage: AssetImage(
                              'assets/images/avatar.png',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Selamat Datang!',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                              Text(
                                _currentUser?.username ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              if (_currentUser?.instansi != null)
                                Text(
                                  _currentUser!.instansi,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // Gambar statis (tanpa slider)
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/dash.jpg', // pilih salah satu dari _sliderImages
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Logo & Description
              Center(
                child: Column(
                  children: [
                    Image.asset('assets/images/noisense.png', height: 50),
                    const SizedBox(height: 4),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Merupakan aplikasi yang dapat membantu pengguna dalam mengetahui zona dengan tingkat kebisingan secara real-time.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Tombol Menu
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildMenuButton(
                      'Panduan',
                      Icons.menu_book,
                      () => Navigator.pushNamed(context, Routes.panduan),
                    ),
                    buildMenuButton(
                      'Edukasi',
                      Icons.school,
                      () => Navigator.pushNamed(context, Routes.edukasi),
                    ),
                    buildMenuButton(
                      'NoiSense',
                      Icons.wifi_tethering,
                      () => Navigator.pushNamed(context, Routes.noisense),
                    ),
                    buildMenuButton(
                      'Feedback',
                      Icons.feedback,
                      () => Navigator.pushNamed(context, Routes.feedback),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Sarana dan Prasarana (Kartu Depo)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Sarana dan Prasarana',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 3 / 2,
                  ),
                  itemCount: _depots.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _buildDepoCard(_depots[index]);
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      // Navigasi Bawah
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) async {
          if (index == 1) {
            final result = await Navigator.pushNamed(context, Routes.profile);
            if (result == 'updated') {
              _loadUserData();
            }
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}