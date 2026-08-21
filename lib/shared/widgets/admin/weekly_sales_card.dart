import 'package:flutter/material.dart';

class WeeklySalesCard extends StatelessWidget {
  const WeeklySalesCard({
    super.key,
    this.barHeights = const [28, 48, 32, 80, 52, 40, 56],
    this.selectedIndex = 3,
  });

  final List<double> barHeights;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEFEFEF), width: 1.5),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Продажи за неделю',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '₽ тыс.',
                style: TextStyle(fontSize: 13, color: Color(0xFF8E8E93)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (int index = 0; index < barHeights.length; index++)
                  Container(
                    width: 32,
                    height: barHeights[index],
                    decoration: BoxDecoration(
                      color: index == selectedIndex
                          ? const Color(0xFF5A49F8)
                          : const Color(0xFFF2F1ED),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
