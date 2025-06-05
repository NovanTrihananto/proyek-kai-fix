import 'package:flutter/material.dart';
import 'package:kai/models/target_location_model.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:kai/screens/noisense/barcode_helper_history.dart';
import 'package:kai/screens/noisense/LBS.dart';// Berisi triggerListLocation

// Fungsi untuk memvalidasi apakah nilai QR cocok dengan nama lokasi bising
bool isValidLokasi(String scannedValue) {
  for (var trigger in triggerListLocation) {
    final lokasi = trigger.lokasi;
    if (lokasi != null) {
        // Cocokkan dengan nama lokasi (tanpa sensitif huruf besar/kecil)
        if (lokasi.nama?.toLowerCase() == scannedValue.toLowerCase()) {
          return true;
      }
    }
  }
  return false;
}

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  bool _isScanned = false; // Untuk mencegah pemindaian ganda

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Barcode Scanner',
          style: TextStyle(
            color: Color(0xFF2C2A6B),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF2C2A6B)),
        elevation: 1,
      ),
      body: Stack(
        children: [
          // Komponen scanner dari package mobile_scanner
          MobileScanner(
            onDetect: (capture) async {
              if (_isScanned) return;

              final List<Barcode> barcodes = capture.barcodes;
              final Barcode barcodeDetected = barcodes.first;
              final String? value = barcodeDetected.rawValue;

              if (value != null && value.isNotEmpty) {
                setState(() => _isScanned = true);

                // Validasi nama lokasi dari barcode
                if (isValidLokasi(value)) {
                  // Simpan ke history
                  await BarcodeHistoryHelper.addToHistory(value);

                  // Arahkan ke halaman LBS
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LBS(barcode: value)),
                  ).then((_) {
                    setState(() => _isScanned = false); // Reset scanner saat kembali
                  });
                } else {
                  // Barcode tidak sesuai dengan data lokasi
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text("QR Tidak Valid"),
                      content: Text("Kode QR tidak sesuai dengan lokasi yang terdaftar."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            setState(() => _isScanned = false);
                          },
                          child: Text("OK"),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
          ),

          // Tampilan overlay kotak panduan QR
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Column(
              children: const [
                Text(
                  'Arahkan Kode QR ke dalam kotak untuk\nmulai memindai',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    width: 250,
                    height: 250,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.fromBorderSide(
                          BorderSide(color: Colors.white, width: 1.5),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
