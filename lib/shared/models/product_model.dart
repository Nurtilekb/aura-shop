class Product {
  final String name;
  final String price;
  final double rating;
  final int? discount;

  const Product({
    required this.name,
    required this.price,
    this.rating = 4.8,
    this.discount,
  });
}
