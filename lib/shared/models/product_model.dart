class Product {
  final String id;
  final String name;
  final String price;
  final double rating;
  final int? discount;
  final String description;
  final String category;
  final String? image;
  final int reviewsCount;
  final bool stock;

  const Product({
    this.id = '',
    required this.name,
    required this.price,
    this.rating = 4.8,
    this.discount,
    this.description = '',
    this.category = 'Обувь',
    this.image,

    this.reviewsCount = 128,
    this.stock = true,
  });
}
