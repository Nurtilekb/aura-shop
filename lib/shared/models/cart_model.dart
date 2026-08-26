import 'package:aurashop/shared/models/product_model.dart';

class CartItem {
  final String id;
  final String productId;
  final String name;
  final double price;
  final String? image;
  final int quantity; // Для корзины - количество, для избранного - всегда 1
  final double rating;
  final int? discount;
  final bool stock;
  final DateTime? addedAt; // Для избранного

  CartItem({
    this.id = '',
    required this.productId,
    required this.name,
    required this.price,
    this.image,
    required this.quantity,
    this.rating = 4.8,
    this.discount,
    this.stock = true,
    this.addedAt,
  });

  factory CartItem.fromProduct(Product product, {int quantity = 1}) {
    return CartItem(
      productId: product.id,
      name: product.name,
      price: product.price,
      image: product.image,
      quantity: quantity,
      rating: product.rating,
      discount: product.discount,
      stock: product.stock,
    );
  }

  // Фабрика для избранного
  factory CartItem.fromFavorite(Product product) {
    return CartItem(
      productId: product.id,
      name: product.name,
      price: product.price,
      image: product.image,
      quantity: 1, // В избранном всегда 1
      rating: product.rating,
      discount: product.discount,
      stock: product.stock,
      addedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      'productId': productId,
      'name': name,
      'price': price,
      'image': image,
      'quantity': quantity,
      'rating': rating,
      'discount': discount,
      'stock': stock,
    };

    // Добавляем addedAt только для избранного
    if (addedAt != null) {
      map['addedAt'] = addedAt!.toIso8601String();
    }

    return map;
  }

  factory CartItem.fromMap(Map<String, dynamic> map, String id) {
    final rawPrice = map['price'];
    final rawQuantity = map['quantity'];
    return CartItem(
      id: id,
      productId: map['productId']?.toString() ?? id,
      name: map['name']?.toString() ?? '',
      price: rawPrice is num
          ? rawPrice.toDouble()
          : double.tryParse(rawPrice?.toString() ?? '') ?? 0,
      image: map['image']?.toString(),
      quantity: rawQuantity is num ? rawQuantity.toInt() : 1,
      rating: (map['rating'] as num?)?.toDouble() ?? 4.8,
      discount: map['discount'],
      stock: map['stock'] ?? true,
      addedAt: map['addedAt'] != null ? DateTime.parse(map['addedAt']) : null,
    );
  }

  CartItem copyWith({
    String? id,
    String? productId,
    String? name,
    double? price,
    String? image,
    int? quantity,
    double? rating,
    int? discount,
    bool? stock,
    DateTime? addedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
      rating: rating ?? this.rating,
      discount: discount ?? this.discount,
      stock: stock ?? this.stock,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  // Вспомогательный метод для проверки, является ли товар в избранном
  bool get isFavorite => addedAt != null;

  // Вспомогательный метод для преобразования в Product (если нужно)
  Product toProduct() {
    return Product(
      id: productId,
      name: name,
      price: price,
      rating: rating,
      discount: discount,
      description: '',
      category: '',
      image: image,
      reviewsCount: 0,
      stock: stock,
    );
  }
}
