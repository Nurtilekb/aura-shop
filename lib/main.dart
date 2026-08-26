import 'package:aurashop/bloc/messages/messages_bloc.dart';
import 'package:aurashop/bloc/products/products_bloc.dart';
import 'package:aurashop/core/routing/app_router.dart';
import 'package:aurashop/core/routing/app_router.gr.dart';
import 'package:aurashop/bloc/auth/auth_bloc.dart';
import 'package:aurashop/bloc/auth/auth_state.dart';
import 'package:aurashop/bloc/theme/theme_bloc.dart';
import 'package:aurashop/firebase_options.dart';
import 'package:aurashop/repositories/auth_repository.dart';

import 'package:aurashop/repositories/product_repository.dart';
import 'package:aurashop/features/basket/presentation/screens/basket_screen.dart';
import 'package:aurashop/features/catalog/presentation/screens/categories_screen.dart'
    hide ProductRepository;
import 'package:aurashop/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:aurashop/features/home/presentation/screens/home_screen.dart';
import 'package:aurashop/features/profile/presentation/screens/profile_screen.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MessagesBloc()),
        BlocProvider(
          create: (_) => ProductsBloc(productRepository: ProductRepository()),
        ),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(
          create: (_) => AuthBloc(
            authRepository: AuthRepository(
              googleServerClientId:
                  '497949764516-g2cuenbqpci4dupgs4dhk5muhrujvg38.apps.googleusercontent.com',
            ),
          ),
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) =>
            current is AuthUnauthenticated && previous is! AuthUnauthenticated,
        listener: (context, state) {
          _appRouter.replaceAll([const SplashRoute()]);
        },
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: state.buildTheme(Brightness.light),
              darkTheme: state.buildTheme(Brightness.dark),
              themeMode: state.themeMode == ThemeModeStatus.light
                  ? ThemeMode.light
                  : state.themeMode == ThemeModeStatus.dark
                  ? ThemeMode.dark
                  : ThemeMode.system,
              routerConfig: _appRouter.config(),
            );
          },
        ),
      ),
    );
  }
}

@RoutePage()
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    AllCategoriesScreen(),
    CartScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(color: colorScheme.outlineVariant, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: colorScheme.onSurfaceVariant,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Главная',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view),
              label: 'Каталог',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              label: 'Корзина',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined),
              label: 'Избранное',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_4_outlined),
              label: 'Профиль',
            ),
          ],
        ),
      ),
    );
  }
}
