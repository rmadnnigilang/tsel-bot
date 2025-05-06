class InternetPackage {
  final String name;
  final String description;
  final int quota;
  final int duration;
  final int id;
  final double price;

  InternetPackage({
    required this.name,
    required this.description,
    required this.quota,
    required this.duration,
    required this.id,
    required this.price,
  });

  factory InternetPackage.fromJson(Map<String, dynamic> json) {
    return InternetPackage(
      id: json['id'] ?? 0,
      name: json['package_name'] ?? 'Tanpa Nama',
      description: json['package_description'] ?? '-', // ✅ perbaikan disini
      quota: json['quota'] ?? 0,
      duration: json['duration'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}
