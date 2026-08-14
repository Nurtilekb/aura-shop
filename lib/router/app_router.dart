import 'package:aurashop/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegistrationRoute.page),
    AutoRoute(page: VerificationRoute.page),
    AutoRoute(page: SettingsRoute.page),
    AutoRoute(page: SplashRoute.page),
    AutoRoute(page: HomeRoute.page, initial: true),
  ];
}
