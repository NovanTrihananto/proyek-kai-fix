import 'package:flutter/material.dart';
import 'package:kai/screens/dashboard_screen.dart';
import 'package:kai/screens/noisense/noisense_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:kai/screens/noisense/LBS.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  bool _isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Barcode Scanner')),
      body: MobileScanner(
        onDetect: (capture) {
          if (_isScanned) return;

          final List<Barcode> barcodes = capture.barcodes;
          final Barcode barcodeDetected = barcodes.first;
          final String? value = barcodeDetected.rawValue;

          if (value != null && value.isNotEmpty) {
            setState(() => _isScanned = true);

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LBS(barcode: value)),
            ).then((_) {
              // Reset scanner
              setState(() => _isScanned = false);
            });
          }
        },
      ),
    );
  }
}
