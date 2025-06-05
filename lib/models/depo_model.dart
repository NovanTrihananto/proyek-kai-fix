// lib/models/depot_model.dart
class DepoModel {
  final String title;
  final String
  thumbnailImagePath; // Mengganti imagePath menjadi thumbnailImagePath
  final String detailImagePath; // Properti baru untuk gambar di halaman detail
  final String description;
  final String employeeCount;
  final String equipmentDescription;
  final String capabilities;
  final String loko;

  DepoModel({
    required this.title,
    required this.thumbnailImagePath, // Perbarui konstruktor
    required this.detailImagePath, // Tambahkan properti baru
    required this.description,
    required this.employeeCount,
    required this.equipmentDescription,
    required this.capabilities,
    required this.loko,
  });
}
