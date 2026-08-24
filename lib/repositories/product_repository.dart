import 'package:aurashop/shared/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductRepository {
  final FirebaseFirestore _firestore;

  ProductRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _products =>
      _firestore.collection('products');

  Stream<List<Product>> watchProducts() {
    return _products.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => Product.fromFirestore(doc.data(), doc.id))
          .toList(growable: false),
    );
  }

  Future<List<Product>> getProducts() async {
    final snapshot = await _products.get();
    return snapshot.docs
        .map((doc) => Product.fromFirestore(doc.data(), doc.id))
        .toList(growable: false);
  }

  Future<Product?> getProductById(String id) async {
    if (id.isEmpty) return null;

    final snapshot = await _products.doc(id).get();
    final data = snapshot.data();
    if (!snapshot.exists || data == null) return null;

    return Product.fromFirestore(data, snapshot.id);
  }

  Future<Product> addProduct(Product product) async {
    final document = _products.doc();
    await document.set(product.toFirestore());
    return product.copyWith(id: document.id);
  }

  Future<void> updateProduct(Product product) async {
    if (product.id.isEmpty) {
      throw ArgumentError('Для обновления товара нужен id');
    }

    await _products.doc(product.id).update(product.toFirestore());
  }

  Future<void> deleteProduct(String id) async {
    if (id.isEmpty) return;
    await _products.doc(id).delete();
  }
}
