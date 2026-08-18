import 'package:flutter/material.dart';

/// Элемент списка меню с иконкой, заголовком и опциональным бэйджем
class MenuItem extends StatelessWidget {
  final String emaji;

  final String title;
  final String? badgeText;
  final VoidCallback onTap;

  const MenuItem({
    required this.emaji,

    required this.title,
    this.badgeText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: onTap,
          leading: SizedBox(
            width: 45,
            height: 45,
            child: Center(child: Text(emaji, style: TextStyle(fontSize: 20))),
          ),

          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (badgeText != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBE6FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badgeText!,
                    style: const TextStyle(
                      color: Color(0xFF6C5CE7),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
            ],
          ),
        ),
        Divider(height: 1, thickness: 0.8, color: Colors.grey.shade200),
      ],
    );
  }
}
