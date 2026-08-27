// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:aurashop/admin_features/chats/presentation/screens/chats_screen.dart'
    as _i26;
import 'package:aurashop/admin_features/dashboard/presentation/screens/dashboard_screen.dart'
    as _i8;
import 'package:aurashop/admin_features/dashboard/presentation/screens/main_screen_admin.dart'
    as _i13;
import 'package:aurashop/admin_features/dashboard/presentation/screens/profile_admin_screen.dart'
    as _i3;
import 'package:aurashop/admin_features/orders/presentation/screens/admin_orders_screen.dart'
    as _i2;
import 'package:aurashop/admin_features/products/presentation/screens/add_new_product_screen.dart'
    as _i1;
import 'package:aurashop/admin_features/products/presentation/screens/product_screen_admin.dart'
    as _i20;
import 'package:aurashop/features/auth/presentation/screens/login_screen.dart'
    as _i12;
import 'package:aurashop/features/auth/presentation/screens/registrarion_screen.dart'
    as _i22;
import 'package:aurashop/features/auth/presentation/screens/verification_screen.dart'
    as _i27;
import 'package:aurashop/features/basket/presentation/screens/basket_screen.dart'
    as _i5;
import 'package:aurashop/features/basket/presentation/screens/confirm_orders_screen.dart'
    as _i7;
import 'package:aurashop/features/basket/presentation/screens/order_success_screen.dart'
    as _i16;
import 'package:aurashop/features/catalog/presentation/screens/categories_screen.dart'
    as _i4;
import 'package:aurashop/features/catalog/presentation/screens/product_detail_screen.dart'
    as _i19;
import 'package:aurashop/features/favorites/presentation/screens/favorites_screen.dart'
    as _i10;
import 'package:aurashop/features/home/presentation/screens/home_screen.dart'
    as _i11;
import 'package:aurashop/features/profile/presentation/screens/edit_profile_screen.dart'
    as _i9;
import 'package:aurashop/features/profile/presentation/screens/inside_chat_screen.dart'
    as _i6;
import 'package:aurashop/features/profile/presentation/screens/my_adresses_screen.dart'
    as _i15;
import 'package:aurashop/features/profile/presentation/screens/my_orders_screen.dart'
    as _i18;
import 'package:aurashop/features/profile/presentation/screens/profile_screen.dart'
    as _i21;
import 'package:aurashop/features/profile/presentation/screens/settings_screen.dart'
    as _i24;
import 'package:aurashop/features/search/presentation/screens/search_screen.dart'
    as _i23;
import 'package:aurashop/features/splash/presentation/screens/splash_screen.dart'
    as _i25;
import 'package:aurashop/features/tracking_order/traking_screen.dart' as _i17;
import 'package:aurashop/main.dart' as _i14;
import 'package:aurashop/shared/models/product_model.dart' as _i30;
import 'package:auto_route/auto_route.dart' as _i28;
import 'package:firebase_auth/firebase_auth.dart' as _i31;
import 'package:flutter/cupertino.dart' as _i29;
import 'package:flutter/material.dart' as _i32;

/// generated route for
/// [_i1.AddNewProductScreen]
class AddNewProductRoute extends _i28.PageRouteInfo<AddNewProductRouteArgs> {
  AddNewProductRoute({
    _i29.Key? key,
    _i30.Product? product2,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         AddNewProductRoute.name,
         args: AddNewProductRouteArgs(key: key, product2: product2),
         initialChildren: children,
       );

  static const String name = 'AddNewProductRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddNewProductRouteArgs>(
        orElse: () => const AddNewProductRouteArgs(),
      );
      return _i1.AddNewProductScreen(key: args.key, product2: args.product2);
    },
  );
}

class AddNewProductRouteArgs {
  const AddNewProductRouteArgs({this.key, this.product2});

  final _i29.Key? key;

  final _i30.Product? product2;

  @override
  String toString() {
    return 'AddNewProductRouteArgs{key: $key, product2: $product2}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AddNewProductRouteArgs) return false;
    return key == other.key && product2 == other.product2;
  }

  @override
  int get hashCode => key.hashCode ^ product2.hashCode;
}

/// generated route for
/// [_i2.AdminOrdersScreen]
class AdminOrdersRoute extends _i28.PageRouteInfo<void> {
  const AdminOrdersRoute({List<_i28.PageRouteInfo>? children})
    : super(AdminOrdersRoute.name, initialChildren: children);

  static const String name = 'AdminOrdersRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i2.AdminOrdersScreen();
    },
  );
}

/// generated route for
/// [_i3.AdminProfileScreen]
class AdminProfileRoute extends _i28.PageRouteInfo<AdminProfileRouteArgs> {
  AdminProfileRoute({
    _i29.Key? key,
    _i31.User? name,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         AdminProfileRoute.name,
         args: AdminProfileRouteArgs(key: key, name: name),
         initialChildren: children,
       );

  static const String name = 'AdminProfileRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AdminProfileRouteArgs>(
        orElse: () => const AdminProfileRouteArgs(),
      );
      return _i3.AdminProfileScreen(key: args.key, name: args.name);
    },
  );
}

class AdminProfileRouteArgs {
  const AdminProfileRouteArgs({this.key, this.name});

  final _i29.Key? key;

  final _i31.User? name;

  @override
  String toString() {
    return 'AdminProfileRouteArgs{key: $key, name: $name}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AdminProfileRouteArgs) return false;
    return key == other.key && name == other.name;
  }

  @override
  int get hashCode => key.hashCode ^ name.hashCode;
}

/// generated route for
/// [_i4.AllCategoriesScreen]
class AllCategoriesRoute extends _i28.PageRouteInfo<void> {
  const AllCategoriesRoute({List<_i28.PageRouteInfo>? children})
    : super(AllCategoriesRoute.name, initialChildren: children);

  static const String name = 'AllCategoriesRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i4.AllCategoriesScreen();
    },
  );
}

/// generated route for
/// [_i5.CartScreen]
class CartRoute extends _i28.PageRouteInfo<void> {
  const CartRoute({List<_i28.PageRouteInfo>? children})
    : super(CartRoute.name, initialChildren: children);

  static const String name = 'CartRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i5.CartScreen();
    },
  );
}

/// generated route for
/// [_i6.ChatsScreen]
class ChatsRoute extends _i28.PageRouteInfo<ChatsRouteArgs> {
  ChatsRoute({
    _i32.Key? key,
    required String numName,
    required bool isOnline,
    required String imageAvatar,
    required String userId,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         ChatsRoute.name,
         args: ChatsRouteArgs(
           key: key,
           numName: numName,
           isOnline: isOnline,
           imageAvatar: imageAvatar,
           userId: userId,
         ),
         initialChildren: children,
       );

  static const String name = 'ChatsRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatsRouteArgs>();
      return _i6.ChatsScreen(
        key: args.key,
        numName: args.numName,
        isOnline: args.isOnline,
        imageAvatar: args.imageAvatar,
        userId: args.userId,
      );
    },
  );
}

class ChatsRouteArgs {
  const ChatsRouteArgs({
    this.key,
    required this.numName,
    required this.isOnline,
    required this.imageAvatar,
    required this.userId,
  });

  final _i32.Key? key;

  final String numName;

  final bool isOnline;

  final String imageAvatar;

  final String userId;

  @override
  String toString() {
    return 'ChatsRouteArgs{key: $key, numName: $numName, isOnline: $isOnline, imageAvatar: $imageAvatar, userId: $userId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChatsRouteArgs) return false;
    return key == other.key &&
        numName == other.numName &&
        isOnline == other.isOnline &&
        imageAvatar == other.imageAvatar &&
        userId == other.userId;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      numName.hashCode ^
      isOnline.hashCode ^
      imageAvatar.hashCode ^
      userId.hashCode;
}

/// generated route for
/// [_i7.ConfirmOrderScreen]
class ConfirmOrderRoute extends _i28.PageRouteInfo<void> {
  const ConfirmOrderRoute({List<_i28.PageRouteInfo>? children})
    : super(ConfirmOrderRoute.name, initialChildren: children);

  static const String name = 'ConfirmOrderRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i7.ConfirmOrderScreen();
    },
  );
}

/// generated route for
/// [_i8.DashboardScreenAdmin]
class DashboardRouteAdmin extends _i28.PageRouteInfo<void> {
  const DashboardRouteAdmin({List<_i28.PageRouteInfo>? children})
    : super(DashboardRouteAdmin.name, initialChildren: children);

  static const String name = 'DashboardRouteAdmin';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i8.DashboardScreenAdmin();
    },
  );
}

/// generated route for
/// [_i9.EditProfileScreen]
class EditProfileRoute extends _i28.PageRouteInfo<EditProfileRouteArgs> {
  EditProfileRoute({
    _i32.Key? key,
    String? currentName,
    String? birthday,
    String? currentEmail,
    String? initials,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         EditProfileRoute.name,
         args: EditProfileRouteArgs(
           key: key,
           currentName: currentName,
           birthday: birthday,
           currentEmail: currentEmail,
           initials: initials,
         ),
         initialChildren: children,
       );

  static const String name = 'EditProfileRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EditProfileRouteArgs>(
        orElse: () => const EditProfileRouteArgs(),
      );
      return _i9.EditProfileScreen(
        key: args.key,
        currentName: args.currentName,
        birthday: args.birthday,
        currentEmail: args.currentEmail,
        initials: args.initials,
      );
    },
  );
}

class EditProfileRouteArgs {
  const EditProfileRouteArgs({
    this.key,
    this.currentName,
    this.birthday,
    this.currentEmail,
    this.initials,
  });

  final _i32.Key? key;

  final String? currentName;

  final String? birthday;

  final String? currentEmail;

  final String? initials;

  @override
  String toString() {
    return 'EditProfileRouteArgs{key: $key, currentName: $currentName, birthday: $birthday, currentEmail: $currentEmail, initials: $initials}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EditProfileRouteArgs) return false;
    return key == other.key &&
        currentName == other.currentName &&
        birthday == other.birthday &&
        currentEmail == other.currentEmail &&
        initials == other.initials;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      currentName.hashCode ^
      birthday.hashCode ^
      currentEmail.hashCode ^
      initials.hashCode;
}

/// generated route for
/// [_i10.FavoritesScreen]
class FavoritesRoute extends _i28.PageRouteInfo<void> {
  const FavoritesRoute({List<_i28.PageRouteInfo>? children})
    : super(FavoritesRoute.name, initialChildren: children);

  static const String name = 'FavoritesRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i10.FavoritesScreen();
    },
  );
}

/// generated route for
/// [_i11.HomeScreen]
class HomeRoute extends _i28.PageRouteInfo<void> {
  const HomeRoute({List<_i28.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i11.HomeScreen();
    },
  );
}

/// generated route for
/// [_i12.LoginScreen]
class LoginRoute extends _i28.PageRouteInfo<void> {
  const LoginRoute({List<_i28.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i12.LoginScreen();
    },
  );
}

/// generated route for
/// [_i13.Main2Screen]
class Main2Route extends _i28.PageRouteInfo<void> {
  const Main2Route({List<_i28.PageRouteInfo>? children})
    : super(Main2Route.name, initialChildren: children);

  static const String name = 'Main2Route';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i13.Main2Screen();
    },
  );
}

/// generated route for
/// [_i14.MainScreen]
class MainRoute extends _i28.PageRouteInfo<void> {
  const MainRoute({List<_i28.PageRouteInfo>? children})
    : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i14.MainScreen();
    },
  );
}

/// generated route for
/// [_i15.MyAdressesScreen]
class MyAdressesRoute extends _i28.PageRouteInfo<void> {
  const MyAdressesRoute({List<_i28.PageRouteInfo>? children})
    : super(MyAdressesRoute.name, initialChildren: children);

  static const String name = 'MyAdressesRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i15.MyAdressesScreen();
    },
  );
}

/// generated route for
/// [_i16.OrderSuccessScreen]
class OrderSuccessRoute extends _i28.PageRouteInfo<OrderSuccessRouteArgs> {
  OrderSuccessRoute({
    _i32.Key? key,
    String orderNumber = '#AU-24815',
    String deliveryTime = 'завтра, 10:00–22:00',
    _i32.VoidCallback? onTrackOrder,
    _i32.VoidCallback? onContinueShopping,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         OrderSuccessRoute.name,
         args: OrderSuccessRouteArgs(
           key: key,
           orderNumber: orderNumber,
           deliveryTime: deliveryTime,
           onTrackOrder: onTrackOrder,
           onContinueShopping: onContinueShopping,
         ),
         initialChildren: children,
       );

  static const String name = 'OrderSuccessRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrderSuccessRouteArgs>(
        orElse: () => const OrderSuccessRouteArgs(),
      );
      return _i16.OrderSuccessScreen(
        key: args.key,
        orderNumber: args.orderNumber,
        deliveryTime: args.deliveryTime,
        onTrackOrder: args.onTrackOrder,
        onContinueShopping: args.onContinueShopping,
      );
    },
  );
}

class OrderSuccessRouteArgs {
  const OrderSuccessRouteArgs({
    this.key,
    this.orderNumber = '#AU-24815',
    this.deliveryTime = 'завтра, 10:00–22:00',
    this.onTrackOrder,
    this.onContinueShopping,
  });

  final _i32.Key? key;

  final String orderNumber;

  final String deliveryTime;

  final _i32.VoidCallback? onTrackOrder;

  final _i32.VoidCallback? onContinueShopping;

  @override
  String toString() {
    return 'OrderSuccessRouteArgs{key: $key, orderNumber: $orderNumber, deliveryTime: $deliveryTime, onTrackOrder: $onTrackOrder, onContinueShopping: $onContinueShopping}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OrderSuccessRouteArgs) return false;
    return key == other.key &&
        orderNumber == other.orderNumber &&
        deliveryTime == other.deliveryTime &&
        onTrackOrder == other.onTrackOrder &&
        onContinueShopping == other.onContinueShopping;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      orderNumber.hashCode ^
      deliveryTime.hashCode ^
      onTrackOrder.hashCode ^
      onContinueShopping.hashCode;
}

/// generated route for
/// [_i17.OrderTrackingPage]
class OrderTrackingPage extends _i28.PageRouteInfo<void> {
  const OrderTrackingPage({List<_i28.PageRouteInfo>? children})
    : super(OrderTrackingPage.name, initialChildren: children);

  static const String name = 'OrderTrackingPage';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i17.OrderTrackingPage();
    },
  );
}

/// generated route for
/// [_i18.OrdersScreen]
class OrdersRoute extends _i28.PageRouteInfo<OrdersRouteArgs> {
  OrdersRoute({
    _i32.Key? key,
    String? foradminAppbar,
    bool? isItAdmin,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         OrdersRoute.name,
         args: OrdersRouteArgs(
           key: key,
           foradminAppbar: foradminAppbar,
           isItAdmin: isItAdmin,
         ),
         initialChildren: children,
       );

  static const String name = 'OrdersRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrdersRouteArgs>(
        orElse: () => const OrdersRouteArgs(),
      );
      return _i18.OrdersScreen(
        key: args.key,
        foradminAppbar: args.foradminAppbar,
        isItAdmin: args.isItAdmin,
      );
    },
  );
}

class OrdersRouteArgs {
  const OrdersRouteArgs({this.key, this.foradminAppbar, this.isItAdmin});

  final _i32.Key? key;

  final String? foradminAppbar;

  final bool? isItAdmin;

  @override
  String toString() {
    return 'OrdersRouteArgs{key: $key, foradminAppbar: $foradminAppbar, isItAdmin: $isItAdmin}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OrdersRouteArgs) return false;
    return key == other.key &&
        foradminAppbar == other.foradminAppbar &&
        isItAdmin == other.isItAdmin;
  }

  @override
  int get hashCode =>
      key.hashCode ^ foradminAppbar.hashCode ^ isItAdmin.hashCode;
}

/// generated route for
/// [_i19.ProductDetailScreen]
class ProductDetailRoute extends _i28.PageRouteInfo<ProductDetailRouteArgs> {
  ProductDetailRoute({
    _i32.Key? key,
    required _i30.Product product,
    bool? isFavorite,
    _i32.VoidCallback? onFavoriteTap,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         ProductDetailRoute.name,
         args: ProductDetailRouteArgs(
           key: key,
           product: product,
           isFavorite: isFavorite,
           onFavoriteTap: onFavoriteTap,
         ),
         initialChildren: children,
       );

  static const String name = 'ProductDetailRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProductDetailRouteArgs>();
      return _i19.ProductDetailScreen(
        key: args.key,
        product: args.product,
        isFavorite: args.isFavorite,
        onFavoriteTap: args.onFavoriteTap,
      );
    },
  );
}

class ProductDetailRouteArgs {
  const ProductDetailRouteArgs({
    this.key,
    required this.product,
    this.isFavorite,
    this.onFavoriteTap,
  });

  final _i32.Key? key;

  final _i30.Product product;

  final bool? isFavorite;

  final _i32.VoidCallback? onFavoriteTap;

  @override
  String toString() {
    return 'ProductDetailRouteArgs{key: $key, product: $product, isFavorite: $isFavorite, onFavoriteTap: $onFavoriteTap}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProductDetailRouteArgs) return false;
    return key == other.key &&
        product == other.product &&
        isFavorite == other.isFavorite &&
        onFavoriteTap == other.onFavoriteTap;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      product.hashCode ^
      isFavorite.hashCode ^
      onFavoriteTap.hashCode;
}

/// generated route for
/// [_i20.ProductScreenAdmin]
class ProductRouteAdmin extends _i28.PageRouteInfo<void> {
  const ProductRouteAdmin({List<_i28.PageRouteInfo>? children})
    : super(ProductRouteAdmin.name, initialChildren: children);

  static const String name = 'ProductRouteAdmin';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i20.ProductScreenAdmin();
    },
  );
}

/// generated route for
/// [_i21.ProfileScreen]
class ProfileRoute extends _i28.PageRouteInfo<void> {
  const ProfileRoute({List<_i28.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i21.ProfileScreen();
    },
  );
}

/// generated route for
/// [_i22.RegistrationScreen]
class RegistrationRoute extends _i28.PageRouteInfo<void> {
  const RegistrationRoute({List<_i28.PageRouteInfo>? children})
    : super(RegistrationRoute.name, initialChildren: children);

  static const String name = 'RegistrationRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i22.RegistrationScreen();
    },
  );
}

/// generated route for
/// [_i23.SearchScreen]
class SearchRoute extends _i28.PageRouteInfo<void> {
  const SearchRoute({List<_i28.PageRouteInfo>? children})
    : super(SearchRoute.name, initialChildren: children);

  static const String name = 'SearchRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i23.SearchScreen();
    },
  );
}

/// generated route for
/// [_i24.SettingsScreen]
class SettingsRoute extends _i28.PageRouteInfo<void> {
  const SettingsRoute({List<_i28.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i24.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i25.SplashScreen]
class SplashRoute extends _i28.PageRouteInfo<void> {
  const SplashRoute({List<_i28.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i25.SplashScreen();
    },
  );
}

/// generated route for
/// [_i26.SupportChatsScreen]
class SupportChatsRoute extends _i28.PageRouteInfo<void> {
  const SupportChatsRoute({List<_i28.PageRouteInfo>? children})
    : super(SupportChatsRoute.name, initialChildren: children);

  static const String name = 'SupportChatsRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      return const _i26.SupportChatsScreen();
    },
  );
}

/// generated route for
/// [_i27.VerificationScreen]
class VerificationRoute extends _i28.PageRouteInfo<VerificationRouteArgs> {
  VerificationRoute({
    _i32.Key? key,
    required String email,
    List<_i28.PageRouteInfo>? children,
  }) : super(
         VerificationRoute.name,
         args: VerificationRouteArgs(key: key, email: email),
         initialChildren: children,
       );

  static const String name = 'VerificationRoute';

  static _i28.PageInfo page = _i28.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VerificationRouteArgs>();
      return _i27.VerificationScreen(key: args.key, email: args.email);
    },
  );
}

class VerificationRouteArgs {
  const VerificationRouteArgs({this.key, required this.email});

  final _i32.Key? key;

  final String email;

  @override
  String toString() {
    return 'VerificationRouteArgs{key: $key, email: $email}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VerificationRouteArgs) return false;
    return key == other.key && email == other.email;
  }

  @override
  int get hashCode => key.hashCode ^ email.hashCode;
}
