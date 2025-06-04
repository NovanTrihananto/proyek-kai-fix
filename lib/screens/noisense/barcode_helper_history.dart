import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BarcodeHistoryHelper {
  static const String _key = 'barcode_history';

  // Tambah riwayat baru
  static Future<void> addToHistory(String value) async {
    final prefs = await SharedPreferences.getInstance();

    // Ambil riwayat lama
    final List<String> historyList = prefs.getStringList(_key) ?? [];

    // Ambil waktu sekarang
    final timestamp = DateTime.now().toIso8601String();

    // Buat item dalam bentuk Map
    final newEntry = jsonEncode({
      'value': value,
      'timestamp': timestamp,
    });

    // Tambah ke depan
    historyList.insert(0, newEntry);

    // Batasi hanya 5 riwayat
    if (historyList.length > 5) {
      historyList.removeLast();
    }

    await prefs.setStringList(_key, historyList);
  }

  // Ambil semua riwayat
  static Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> historyList = prefs.getStringList(_key) ?? [];

    return historyList.map((entry) {
      final decoded = jsonDecode(entry);
      return {
        'value': decoded['value'],
        'timestamp': decoded['timestamp'],
      };
    }).toList();
  }
}
