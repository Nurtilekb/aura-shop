import 'dart:async';
import 'package:aurashop/bloc/theme/theme_bloc.dart';
import 'package:flutter/material.dart';

class BannerWidget extends StatefulWidget {
  final List<BannerData> banners;
  final double height;
  final Duration autoScrollDuration;
  final Duration animationDuration;
  final ThemeState? state;

  final Color color;

  const BannerWidget({
    super.key,
    required this.banners,
    this.height = 180,
    this.autoScrollDuration = const Duration(seconds: 4),
    this.animationDuration = const Duration(milliseconds: 500),

    required this.color,
    this.state,
  });

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(widget.autoScrollDuration, (timer) {
      if (widget.banners.isEmpty) return;

      final nextPage = (_currentPage + 1) % widget.banners.length;
      _pageController.animateToPage(
        nextPage,
        duration: widget.animationDuration,
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        Container(
          height: widget.height,
          margin: const EdgeInsets.only(top: 8, bottom: 25),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: widget.banners.length,
              itemBuilder: (context, index) {
                final banner = widget.banners[index];
                return GestureDetector(
                  onTap: banner.onTap,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient:
                          banner.gradient ??
                          LinearGradient(
                            colors: [
                              Colors.blue,
                              Colors.blue.withValues(alpha: 0.7),
                            ],

                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  banner.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                if (banner.subtitle != null)
                                  Text(
                                    banner.subtitle!,
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.85,
                                      ),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                if (banner.actionText != null) ...[
                                  const SizedBox(height: 14),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      banner.actionText!,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Icon(
                              banner.icon,
                              size: 72,
                              color: Colors.white.withValues(alpha: 0.25),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.banners.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentPage == index ? 24 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? widget.state?.directAccentColor
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BannerData {
  final String title;
  final String? subtitle;
  final String? actionText;
  final IconData icon;
  final Gradient? gradient;
  final VoidCallback? onTap;

  BannerData({
    required this.title,
    this.subtitle,
    this.actionText,
    this.icon = Icons.card_giftcard_rounded,
    this.gradient,
    this.onTap,
  });
}
