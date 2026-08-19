// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:aurashop/main.dart' as _i5;
import 'package:aurashop/features/auth/presentation/login_screen.dart' as _i4;
import 'package:aurashop/features/auth/presentation/registrarion_screen.dart'
    as _i7;
import 'package:aurashop/features/auth/presentation/verification_screen.dart'
    as _i10;
import 'package:aurashop/features/basket/presentation/confirm_orders_screen.dart'
    as _i1;
import 'package:aurashop/features/favorites/presentation/favorites_screen.dart'
    as _i2;
import 'package:aurashop/features/home/presentation/home_screen.dart' as _i3;
import 'package:aurashop/features/profile/presentation/progile_screen.dart'
    as _i6;
import 'package:aurashop/features/profile/presentation/settings_screen.dart'
    as _i8;
import 'package:aurashop/features/splash/presentation/splash_screen.dart'
    as _i9;
import 'package:auto_route/auto_route.dart' as _i11;
import 'package:flutter/material.dart' as _i12;

/// generated route for
/// [_i1.ConfirmOrder]
class ConfirmOrder extends _i11.PageRouteInfo<void> {
  const ConfirmOrder({List<_i11.PageRouteInfo>? children})
    : super(ConfirmOrder.name, initialChildren: children);

  static const String name = 'ConfirmOrder';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i1.ConfirmOrder();
    },
  );
}

/// generated route for
/// [_i2.FavoritesScreen]
class FavoritesRoute extends _i11.PageRouteInfo<void> {
  const FavoritesRoute({List<_i11.PageRouteInfo>? children})
    : super(FavoritesRoute.name, initialChildren: children);

  static const String name = 'FavoritesRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i2.FavoritesScreen();
    },
  );
}

/// generated route for
/// [_i3.HomeScreen]
class HomeRoute extends _i11.PageRouteInfo<void> {
  const HomeRoute({List<_i11.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i3.HomeScreen();
    },
  );
}

/// generated route for
/// [_i4.LoginScreen]
class LoginRoute extends _i11.PageRouteInfo<void> {
  const LoginRoute({List<_i11.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i4.LoginScreen();
    },
  );
}

/// generated route for
/// [_i5.MainScreen]
class MainRoute extends _i11.PageRouteInfo<void> {
  const MainRoute({List<_i11.PageRouteInfo>? children})
    : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i5.MainScreen();
    },
  );
}

/// generated route for
/// [_i6.ProfileScreen]
class ProfileRoute extends _i11.PageRouteInfo<void> {
  const ProfileRoute({List<_i11.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i6.ProfileScreen();
    },
  );
}

/// generated route for
/// [_i7.RegistrationScreen]
class RegistrationRoute extends _i11.PageRouteInfo<void> {
  const RegistrationRoute({List<_i11.PageRouteInfo>? children})
    : super(RegistrationRoute.name, initialChildren: children);

  static const String name = 'RegistrationRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i7.RegistrationScreen();
    },
  );
}

/// generated route for
/// [_i8.SettingsScreen]
class SettingsRoute extends _i11.PageRouteInfo<void> {
  const SettingsRoute({List<_i11.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i8.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i9.SplashScreen]
class SplashRoute extends _i11.PageRouteInfo<void> {
  const SplashRoute({List<_i11.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i9.SplashScreen();
    },
  );
}

/// generated route for
/// [_i10.VerificationScreen]
class VerificationRoute extends _i11.PageRouteInfo<VerificationRouteArgs> {
  VerificationRoute({
    _i12.Key? key,
    required String email,
    List<_i11.PageRouteInfo>? children,
  }) : super(
         VerificationRoute.name,
         args: VerificationRouteArgs(key: key, email: email),
         initialChildren: children,
       );

  static const String name = 'VerificationRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VerificationRouteArgs>();
      return _i10.VerificationScreen(key: args.key, email: args.email);
    },
  );
}

class VerificationRouteArgs {
  const VerificationRouteArgs({this.key, required this.email});

  final _i12.Key? key;

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
