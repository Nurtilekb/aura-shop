import 'package:aurashop/bloc/theme/theme_bloc.dart';
import 'package:aurashop/features/catalog/presentation/screens/categories_screen.dart';
import 'package:aurashop/features/search/presentation/screens/search_screen.dart';
import 'package:aurashop/shared/widgets/app_input_widget.dart';
import 'package:aurashop/shared/widgets/banner_widget.dart';
import 'package:aurashop/shared/widgets/custom_widgets/iconwith_background_widget.dart';
import 'package:aurashop/shared/widgets/production_card_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController scrollController;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final banners = [
      [
        'Скидка 30%',
        'На все товары этой недели',
        Icons.local_offer_rounded,
        [Colors.purple, Color(0xFFD1A3FF)],
        'Купить сейчас',
      ],
      [
        'Новинки',
        'Свежие поступления',
        Icons.shopping_bag_rounded,
        [Colors.blue, Color(0xFF66B2FF)],
        'Смотреть',
      ],
      [
        'Бесплатная доставка',
        'При заказе от 5000 ₽',
        Icons.local_shipping_rounded,
        [Colors.orange, Color(0xFFFFBE7D)],
        'Заказать',
      ],
    ];
    final imagesPath1 = ["👕", "👟", "📱", "🏠"];
    final categoryNames = ["Одежда", "Обувь", "Гаджеты", "Дом"];
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              'Доставка в Москву',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Привет, Анна',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        IconWithBack(
                          ontap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchScreen(),
                              ),
                            );
                          },
                          backroundcolor: Colors.white,
                          forborder: Border.all(width: 0.5, color: Colors.grey),
                          bordRadius: BorderRadius.circular(15),
                          emoji: '🔍',
                          emojiSizes: 25,
                          sizes: 50,
                        ),
                        SizedBox(width: 10),
                        IconWithBack(
                          ontap: () {},
                          backroundcolor: Colors.white,
                          forborder: Border.all(width: 0.5, color: Colors.grey),
                          bordRadius: BorderRadius.circular(15),
                          emoji: '🛍',
                          emojiSizes: 25,
                          sizes: 50,
                        ),
                      ],
                    ),
                  ),
                ),
                PinnedHeaderSliver(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: AppInputWidget(
                        isBorder: false,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 15,
                        ),
                        filledColor: Colors.transparent,
                        hintText: 'Поиск товаров...',
                        leading: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('🔍', style: TextStyle(fontSize: 20)),
                        ),
                        trailing: Icon(Icons.settings, size: 15),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: BannerWidget(
                      state: state,
                      height: 200,
                      banners: banners
                          .map(
                            (b) => BannerData(
                              title: b[0] as String,
                              subtitle: b[1] as String,
                              icon: b[2] as IconData,
                              actionText: b[4] as String,
                              gradient: LinearGradient(
                                colors: b[3] as List<Color>,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              onTap: () {},
                            ),
                          )
                          .toList(),
                      color: Colors.purple,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Категории',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Все',
                            style: TextStyle(
                              color: state.directAccentColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: SizedBox(
                      height: 100,
                      child: ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,

                        itemCount: 4,
                        separatorBuilder: (_, _) => SizedBox(width: 30),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              IconWithBack(
                                ontap: () {},
                                backroundcolor: Colors.grey.shade200,
                                emojiSizes: 30,
                                bordRadius: BorderRadius.circular(18),
                                emoji: imagesPath1[index],
                                sizes: 70,
                              ),
                              SizedBox(height: 8),
                              Text(
                                categoryNames[index],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Популярное',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllCategories(),
                              ),
                            );
                          },
                          child: Text(
                            'Смотреть все',
                            style: TextStyle(
                              color: state.directAccentColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
                  sliver: SliverToBoxAdapter(
                    child: SizedBox(
                      height: 250,
                      child: ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) =>
                            Productcard(indexx: index),
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 20),
                        itemCount: 2,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
