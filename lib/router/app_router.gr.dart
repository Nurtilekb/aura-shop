// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:aurashop/screens/login_screen.dart' as _i1;
import 'package:aurashop/screens/registrarion_screen.dart' as _i3;
import 'package:aurashop/screens/settings_screen.dart' as _i4;
import 'package:aurashop/screens/splash_screen.dart' as _i2;
import 'package:aurashop/screens/verification_screen.dart' as _i5;
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:flutter/material.dart' as _i7;

/// generated route for
/// [_i1.LoginScreen]
class LoginRoute extends _i6.PageRouteInfo<void> {
  const LoginRoute({List<_i6.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i1.LoginScreen();
    },
  );
}

/// generated route for
/// [_i2.OnboardingScreen]
class OnboardingRoute extends _i6.PageRouteInfo<void> {
  const OnboardingRoute({List<_i6.PageRouteInfo>? children})
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i2.SplashScreen();
    },
  );
}

/// generated route for
/// [_i3.RegistrationScreen]
class RegistrationRoute extends _i6.PageRouteInfo<void> {
  const RegistrationRoute({List<_i6.PageRouteInfo>? children})
    : super(RegistrationRoute.name, initialChildren: children);

  static const String name = 'RegistrationRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i3.RegistrationScreen();
    },
  );
}

/// generated route for
/// [_i4.SettingsScreen]
class SettingsRoute extends _i6.PageRouteInfo<void> {
  const SettingsRoute({List<_i6.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i4.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i5.VerificationScreen]
class VerificationRoute extends _i6.PageRouteInfo<VerificationRouteArgs> {
  VerificationRoute({
    _i7.Key? key,
    required String email,
    List<_i6.PageRouteInfo>? children,
  }) : super(
         VerificationRoute.name,
         args: VerificationRouteArgs(key: key, email: email),
         initialChildren: children,
       );

  static const String name = 'VerificationRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VerificationRouteArgs>();
      return _i5.VerificationScreen(key: args.key, email: args.email);
    },
  );
}

class VerificationRouteArgs {
  const VerificationRouteArgs({this.key, required this.email});

  final _i7.Key? key;

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
