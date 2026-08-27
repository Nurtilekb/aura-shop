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

  Future<void> addToCart(CartItem item) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Пользователь не авторизован');

    final cartRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(item.productId);

    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(cartRef);

      if (doc.exists) {
        final data = doc.data();
        final currentQty = _safeGetInt(data?['quantity'], 0);
        transaction.update(cartRef, {'quantity': currentQty + item.quantity});
      } else {
        transaction.set(cartRef, item.toMap());
      }
    });
  }

  int _safeGetInt(dynamic value, int defaultValue) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? defaultValue;
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Пользователь не авторизован');

    if (quantity <= 0) {
      await removeFromCart(productId);
      return;
    }
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(productId)
        .update({'quantity': quantity});
  }

  Future<void> removeFromCart(String productId) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Пользователь не авторизован');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(productId)
        .delete();
  }

  Future<void> clearCart() async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Пользователь не авторизован');

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .get();

    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Future<int> getCartCount() async {
    final user = _auth.currentUser;
    if (user == null) return 0;

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .get();

    return snapshot.docs.fold<int>(0, (sum, doc) {
      final qty = _safeGetInt(doc.data()['quantity'], 0);
      return sum + qty;
    });
  }

  // ============ ИЗБРАННОЕ (FAVORITES) ============

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

  Future<void> addToFavorites(CartItem item) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Пользователь не авторизован');

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(item.productId);

    final favoriteItem = item.copyWith(quantity: 1, addedAt: DateTime.now());
    await docRef.set(favoriteItem.toMap());
  }

  Future<void> toggleFavorite(CartItem item) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Пользователь не авторизован');

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(item.productId);

    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.delete();
    } else {
      final favoriteItem = item.copyWith(quantity: 1, addedAt: DateTime.now());
      await docRef.set(favoriteItem.toMap());
    }
  }

  Future<void> removeFromFavorites(String productId) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Пользователь не авторизован');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(productId)
        .delete();
  }

  Future<void> clearFavorites() async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Пользователь не авторизован');

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .get();

    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Future<bool> isFavorite(String productId) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(productId)
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  Future<List<CartItem>> getFavoritesList() async {
    final user = _auth.currentUser;
    if (user == null) return const <CartItem>[];

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .get();

    return snapshot.docs
        .map((doc) => CartItem.fromMap(doc.data(), doc.id))
        .toList();
  }

  // ============ ПРОВЕРКА АВТОРИЗАЦИИ ============

  bool get isAuthenticated => _auth.currentUser != null;
  String? get currentUserId => _auth.currentUser?.uid;

  Future<int> getTotalItemsCount() async {
    final cartCount = await getCartCount();
    final favorites = await getFavoritesList();
    return cartCount + favorites.length;
  }

  // Проверка, есть ли товар в корзине
  Future<bool> isInCart(String productId) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(productId)
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}
