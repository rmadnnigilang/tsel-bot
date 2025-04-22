class Product {
  final String name;
  final String description;
  final int price;
  final String label;
  final String kuota;
  final String masaAktif;
  final String? bonus;
  final String category; // Tambahkan ini

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.label,
    required this.kuota,
    required this.masaAktif,
    this.bonus,
    required this.category, // Wajib diisi
  });
}
