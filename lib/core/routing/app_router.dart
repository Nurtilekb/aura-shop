import 'package:aurashop/core/routing/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    // 1. Initial Flow
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegistrationRoute.page),
    AutoRoute(page: VerificationRoute.page),

    // 2. Client Main Flow
    AutoRoute(page: MainRoute.page),
    AutoRoute(page: HomeRoute.page),
    AutoRoute(page: AllCategoriesRoute.page),
    AutoRoute(page: ProductDetailRoute.page),
    AutoRoute(page: CartRoute.page),
    AutoRoute(page: ConfirmOrderRoute.page),
    AutoRoute(page: OrderSuccessRoute.page),
    AutoRoute(page: FavoritesRoute.page),
    AutoRoute(page: SearchRoute.page),

    // 3. Client Profile Flow
    AutoRoute(page: ProfileRoute.page),
    AutoRoute(page: EditProfileRoute.page),
    AutoRoute(page: MyAdressesRoute.page),
    AutoRoute(page: OrdersRoute.page),
    AutoRoute(page: SettingsRoute.page),
    AutoRoute(page: ChatsRoute.page),

    // 4. Admin Panel Flow
    AutoRoute(page: Main2Route.page),
    AutoRoute(page: DashboardRouteAdmin.page),
    AutoRoute(page: ProductRouteAdmin.page),
    AutoRoute(page: AddNewProductRoute.page),
    AutoRoute(page: AdminOrdersRoute.page),
    AutoRoute(page: AdminProfileRoute.page),
    AutoRoute(page: OrderTrackingPage.page),
  ];
}
