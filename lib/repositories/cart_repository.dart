// lib/repositories/cart_repository.dart
import 'package:aurashop/shared/models/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ============ КОРЗИНА (CART) ============

  Stream<List<CartItem>> watchCart() {
    return _auth.authStateChanges().asyncExpand((user) {
      if (user == null) return Stream.value(const <CartItem>[]);
      return _userCart(user.uid).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => CartItem.fromMap(doc.data(), doc.id))
            .toList(),
      );
    });
  }

  CollectionReference<Map<String, dynamic>> _userCart(String userId) {
    return _firestore.collection('users').doc(userId).collection('cart');
  }

  CollectionReference<Map<String, dynamic>> get _currentUserCart {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Пользователь не авторизован');
    return _userCart(user.uid);
  }

  Future<void> addToCart(CartItem item) async {
    final docRef = _currentUserCart.doc(item.productId);

    final doc = await docRef.get();
    if (doc.exists) {
      final currentQty = doc.data()!['quantity'] as int;
      await docRef.update({'quantity': currentQty + item.quantity});
    } else {
      await docRef.set(item.toMap());
    }
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(productId);
      return;
    }
    await _currentUserCart.doc(productId).update({'quantity': quantity});
  }

  Future<void> removeFromCart(String productId) async {
    await _currentUserCart.doc(productId).delete();
  }

  Future<void> clearCart() async {
    final snapshot = await _currentUserCart.get();

    final batch = _firestore.batch();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Future<int> getCartCount() async {
    final snapshot = await _currentUserCart.get();
    return snapshot.docs.fold<int>(
      0,
      (sum, doc) => sum + (doc.data()['quantity'] as int? ?? 0),
    );
  }

  // ============ ИЗБРАННОЕ (FAVORITES) ============
  // Используем ту же модель CartItem, но с addedAt

  Stream<List<CartItem>> watchFavorites() {
    return _auth.authStateChanges().asyncExpand((user) {
      if (user == null) return Stream.value(const <CartItem>[]);
      return _watchUserFavorites(user.uid);
    });
  }

  Stream<List<CartItem>> _watchUserFavorites(String userId) async* {
    yield const <CartItem>[];
    yield* _userFavorites(userId).snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => CartItem.fromMap(doc.data(), doc.id))
          .toList(),
    );
  }

  CollectionReference<Map<String, dynamic>> _userFavorites(String userId) {
    return _firestore.collection('users').doc(userId).collection('favorites');
  }

  CollectionReference<Map<String, dynamic>> get _currentUserFavorites {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Пользователь не авторизован');
    return _userFavorites(user.uid);
  }

  Future<void> addToFavorites(CartItem item) async {
    final docRef = _currentUserFavorites.doc(item.productId);
    final favoriteItem = item.copyWith(quantity: 1, addedAt: DateTime.now());
    await docRef.set(favoriteItem.toMap());
  }

  Future<void> toggleFavorite(CartItem item) async {
    final docRef = _currentUserFavorites.doc(item.productId);
    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.delete();
    } else {
      final favoriteItem = item.copyWith(quantity: 1, addedAt: DateTime.now());
      await docRef.set(favoriteItem.toMap());
    }
  }

  Future<void> removeFromFavorites(String productId) async {
    await _currentUserFavorites.doc(productId).delete();
  }

  Future<void> clearFavorites() async {
    final snapshot = await _currentUserFavorites.get();

    final batch = _firestore.batch();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Future<bool> isFavorite(String productId) async {
    try {
      final doc = await _currentUserFavorites.doc(productId).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  Future<List<CartItem>> getFavoritesList() async {
    final snapshot = await _currentUserFavorites.get();
    return snapshot.docs
        .map((doc) => CartItem.fromMap(doc.data(), doc.id))
        .toList();
  }

  // ============ ПРОВЕРКА АВТОРИЗАЦИИ ============

  bool get isAuthenticated => _auth.currentUser != null;

  String? get currentUserId => _auth.currentUser?.uid;

  // ============ УНИВЕРСАЛЬНЫЕ МЕТОДЫ ============

  // Получение количества в корзине + избранном
  Future<int> getTotalItemsCount() async {
    final cartCount = await getCartCount();
    final favorites = await getFavoritesList();
    return cartCount + favorites.length;
  }

  // Проверка, есть ли товар в корзине
  Future<bool> isInCart(String productId) async {
    try {
      final doc = await _currentUserCart.doc(productId).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}
