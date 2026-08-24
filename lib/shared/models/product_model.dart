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
    this.category = '',
    this.image,

    this.reviewsCount = 128,
    this.stock = true,
  });

  Product copyWith({
    String? id,
    String? name,
    String? price,
    double? rating,
    int? discount,
    String? description,
    String? category,
    String? image,
    int? reviewsCount,
    bool? stock,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      discount: discount ?? this.discount,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      stock: stock ?? this.stock,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'price': price,
      'rating': rating,
      'discount': discount,
      'description': description,
      'category': category,
      'image': image,
      'reviewsCount': reviewsCount,
      'stock': stock,
    };
  }

  factory Product.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      name: data['name']?.toString() ?? '',
      price: data['price']?.toString() ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 4.8,
      discount: (data['discount'] as num?)?.toInt(),
      description: data['description']?.toString() ?? '',
      category: data['category']?.toString() ?? 'Обувь',
      image: data['image']?.toString(),
      reviewsCount: (data['reviewsCount'] as num?)?.toInt() ?? 128,
      stock: data['stock'] as bool? ?? true,
    );
  }
}
