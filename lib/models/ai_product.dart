class Product {
  final String name;
  final String description;
  final String quota;
  final String recommendation;
  final num? price;

  Product({
    required this.name,
    required this.description,
    required this.quota,
    required this.recommendation,
    this.price,
  });
}
