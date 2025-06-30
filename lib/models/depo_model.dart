class DepoModel {
  final String title;
  final String thumbnailImagePath;
  final String detailImagePath;
  final String description;
  final String employeeCount;
  final String equipmentDescription;
  final String capabilities;
  final String loko;
  final String? rescueTrain; // ← Tambahkan ini

  DepoModel({
    required this.title,
    required this.thumbnailImagePath,
    required this.detailImagePath,
    required this.description,
    required this.employeeCount,
    required this.equipmentDescription,
    required this.capabilities,
    required this.loko,
    this.rescueTrain, // ← Tambahkan ini ke konstruktor
  });
}