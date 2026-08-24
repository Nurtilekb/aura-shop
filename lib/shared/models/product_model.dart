class Product {
  final String id;
  final String name;
  final String price;
  final double rating;
  final int? discount;
  final String description;
  final String category;
  final String? image;
  final List<String> sizes;
  final List<String> colors;
  final int reviewsCount;
  final bool inStock;

  const Product({
    this.id = '',
    required this.name,
    required this.price,
    this.rating = 4.8,
    this.discount,
    this.description =
        'Премиальное качество материалов и стильный современный дизайн. Идеально подходит как для повседневной носки, так и для активного отдыха.',
    this.category = 'Обувь',
    this.image,
    this.sizes = const ['39', '40', '41', '42', '43', '44'],
    this.colors = const ['Черный', 'Белый', 'Серый'],
    this.reviewsCount = 128,
    this.inStock = true,
  });
}
