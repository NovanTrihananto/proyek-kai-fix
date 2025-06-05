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
  final int _currentPage = 0;

  // Definisikan data depo Anda di sini dengan dua jalur gambar berbeda
  final List<DepoModel> _depots = [
  DepoModel(
    title: 'Depo Lokomotif Yogyakarta',
    thumbnailImagePath: 'assets/images/lokoj.jpg',
    detailImagePath: 'assets/maps/lokoy.png',
    description:
        'Depo ini menangani perawatan ringan dan pengisian bahan bakar lokomotif diesel. Terletak dekat Stasiun Tugu, Yogyakarta.',
    employeeCount: '90 orang',
    equipmentDescription:
        'Mesin las, lifting jack, alat ukur tekanan.',
    capabilities:
        'Dapat menangani hingga 20 lokomotif per hari untuk perawatan dan inspeksi rutin.',
    loko:
        'Armada : 32 Lokomotif dan 33 Kereta Rel Disel'
  ),
  DepoModel(
    title: 'Depo Lokomotif Solo Balapan',
    thumbnailImagePath: 'assets/images/lokos.jpg',
    detailImagePath: 'assets/maps/lokos.png',
    description:
        'Depo ini melayani perawatan dan pengujian performa lokomotif diesel di wilayah Solo dan sekitarnya.',
    employeeCount: '58 orang',
    equipmentDescription:
        'Fasilitas perbaikan engine, kelistrikan, dan bogie.',
    capabilities:
        'Mampu memperbaiki hingga 15 lokomotif per hari, termasuk perbaikan berat dan overhaul.',
    loko:
        'Armada : 19 Kereta Rel Disel'
  ),
  DepoModel(
    title: 'Depo Kereta Yogyakarta',
    thumbnailImagePath: 'assets/images/keretaj.png',
    detailImagePath: 'assets/maps/keretay.png',
    description:
        'Depo ini fokus pada perawatan dan kebersihan kereta penumpang yang beroperasi dari dan ke Yogyakarta.',
    employeeCount: '141 orang',
    equipmentDescription:
        'Peralatan AC, sistem pintu, dan kelistrikan kereta.',
    capabilities:
        'Dapat menangani hingga 25 rangkaian kereta penumpang per hari.',
    loko:
        'Armada : 141 Kereta'
  ),
  DepoModel(
    title: 'Depo Kereta Solo Balapan',
    thumbnailImagePath: 'assets/images/keretas.jpeg',
    detailImagePath: 'assets/maps/keretas.png',
    description:
        'Mendukung operasional kereta lokal dan menengah melalui perawatan ringan dan pengecekan rutin.',
    employeeCount: '109 orang',
    equipmentDescription:
        'Pencucian otomatis, pengecekan roda, dan penerangan.',
    capabilities:
        'Menangani sekitar 15 rangkaian kereta per hari untuk inspeksi dan persiapan keberangkatan.',
    loko:
        'Armada : 181 Kereta'
  ),
  DepoModel(
    title: 'Depo Gerbong Rewulu',
    thumbnailImagePath: 'assets/images/rewulu.JPG',
    detailImagePath: 'assets/maps/rewulu.png',
    description:
        'Fasilitas distribusi bahan bakar dan perbaikan gerbong barang yang terhubung langsung dengan jalur kereta.',
    employeeCount: '22 orang',
    equipmentDescription:
        'Crane besar, alat press roda, area perbaikan sasis.',
    capabilities:
        'Mampu memperbaiki hingga 10 gerbong barang secara bersamaan.',
    loko:
        'Armada : GK 30 Ton : 47, GB 25 Ton : 13, GD 40 Ton : 3 \d Jumlah Gerbong : 63',
  ),
  DepoModel(
    title: 'Depo PUK Yogyakarta',
    thumbnailImagePath: 'assets/images/puk.JPG',
    detailImagePath: 'assets/maps/puky.png',
    description:
        'Menangani unit khusus seperti kereta inspeksi dan derek, dengan fokus pada sistem presisi dan keselamatan.',
    employeeCount: '25 orang',
    equipmentDescription:
        'Alat diagnostik elektronik, sistem hidrolik, komponen presisi.',
    capabilities:
        'Mampu merawat hingga 5 unit khusus secara paralel.',
    loko:
        'Armada: ±6 unit kereta inspeksi dan alat berat rel',
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
              loko: depot.loko,
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
                  'Informasi Depo',
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