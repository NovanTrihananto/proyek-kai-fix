import 'package:flutter/material.dart';
import 'package:kai/screens/noisense/barcode_helper_history.dart';
import '../../constants/colors.dart';
import '../../constants/string.dart';
import '../../routes.dart';

class NoisenseScreen extends StatefulWidget {
  const NoisenseScreen({super.key});

  @override
  State<NoisenseScreen> createState() => _NoisenseScreenState();
}

class _NoisenseScreenState extends State<NoisenseScreen> {
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final scans = await BarcodeHistoryHelper.getHistory();
    setState(() => history = scans);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.noisense, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8A2387), Color(0xFFE94057)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Image.asset(
                'assets/images/kereta.jpg',
                height: 180,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Noisense',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Scan QR code untuk mendapatkan informasi lokasi. '
                      'Anda dapat memindai QR code yang tersedia di berbagai lokasi.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed:
                  () => Navigator.pushNamed(
                    context,
                    Routes.barcodeScanner,
                  ).then((_) => loadHistory()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEB6A28),
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(Icons.qr_code_scanner),
              label: Text(
                "Pindai QR Code",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Pemindaian Terakhir',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child:
                  history.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              size: 64,
                              color: AppColors.textLight,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Belum ada pemindaian terbaru',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.separated(
                        itemCount: history.length,
                        separatorBuilder: (_, __) => Divider(),
                        itemBuilder: (context, index) {
                          final entry = history[index];
                          final value = entry['value'] ?? 'Tidak ada data';
                          final time = DateTime.tryParse(
                            entry['timestamp'] ?? '',
                          );
                          final formattedTime =
                              time != null
                                  ? '${time.day}/${time.month}/${time.year} ${time.hour}:${time.minute}'
                                  : 'Waktu tidak valid';

                          return ListTile(
                            leading: Icon(Icons.qr_code_2),
                            title: Text(value),
                            subtitle: Text(formattedTime),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
