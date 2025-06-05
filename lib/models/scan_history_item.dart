// models/scan_history_item.dart
class ScanHistoryItem {
  final String barcode;
  final DateTime timestamp;

  ScanHistoryItem({required this.barcode, required this.timestamp});

  factory ScanHistoryItem.fromJson(Map<String, dynamic> json) {
    return ScanHistoryItem(
      barcode: json['barcode'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
