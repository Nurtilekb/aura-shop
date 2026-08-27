import 'package:flutter/material.dart';

/// Тип диалога для автоматической подстановки иконки и цветовой схемы
enum DialogType { info, success, warning, error, custom }

/// Универсальная функция для вызова модального диалога из любого места
Future<T?> showCustomDialog<T>({
  required BuildContext context,
  required String title,
  String? description,
  Widget? customContent,
  DialogType type = DialogType.info,
  IconData? customIcon,
  Color? accentColor,
  String? primaryButtonText,
  VoidCallback? onPrimaryPressed,
  String? secondaryButtonText,
  VoidCallback? onSecondaryPressed,
  bool isDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: isDismissible,
    builder: (BuildContext dialogContext) {
      return CustomAppDialog(
        title: title,
        description: description,
        customContent: customContent,
        type: type,
        customIcon: customIcon,
        accentColor: accentColor,
        primaryButtonText: primaryButtonText,
        onPrimaryPressed: onPrimaryPressed,
        secondaryButtonText: secondaryButtonText,
        onSecondaryPressed: onSecondaryPressed,
      );
    },
  );
}

class CustomAppDialog extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? customContent;
  final DialogType type;
  final IconData? customIcon;
  final Color? accentColor;
  final String? primaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryPressed;

  const CustomAppDialog({
    super.key,
    required this.title,
    this.description,
    this.customContent,
    this.type = DialogType.info,
    this.customIcon,
    this.accentColor,
    this.primaryButtonText,
    this.onPrimaryPressed,
    this.secondaryButtonText,
    this.onSecondaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    final styleConfig = _getStyleConfig(type);
    final effectiveColor = accentColor ?? styleConfig.color;
    final effectiveIcon = customIcon ?? styleConfig.icon;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (effectiveIcon != null) ...[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: effectiveColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(effectiveIcon, color: effectiveColor, size: 28),
              ),
              const SizedBox(height: 18),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C1C1E),
                letterSpacing: -0.3,
              ),
            ),
            if (description != null && description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                description!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8E8E93),
                  height: 1.4,
                ),
              ),
            ],
            if (customContent != null) ...[
              const SizedBox(height: 16),
              Flexible(child: customContent!),
            ],
            const SizedBox(height: 24),
            Column(
              children: [
                if (primaryButtonText != null) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onPrimaryPressed?.call();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: effectiveColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        primaryButtonText!,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
                if (secondaryButtonText != null) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onSecondaryPressed?.call();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF8E8E93),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        secondaryButtonText!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  _DialogStyle _getStyleConfig(DialogType type) {
    switch (type) {
      case DialogType.info:
        return _DialogStyle(
          icon: Icons.info_outline_rounded,
          color: const Color(0xFF5A49F8),
        );
      case DialogType.success:
        return _DialogStyle(
          icon: Icons.check_circle_outline_rounded,
          color: const Color(0xFF10B981),
        );
      case DialogType.warning:
        return _DialogStyle(
          icon: Icons.warning_amber_rounded,
          color: const Color(0xFFD97706),
        );
      case DialogType.error:
        return _DialogStyle(
          icon: Icons.error_outline_rounded,
          color: const Color(0xFFE53E3E),
        );
      case DialogType.custom:
        return _DialogStyle(icon: null, color: const Color(0xFF5A49F8));
    }
  }
}

class _DialogStyle {
  final IconData? icon;
  final Color color;

  _DialogStyle({required this.icon, required this.color});
}

// ==========================================
// ПРИМЕРЫ ВЫЗОВА В ЛЮБОЙ ЧАСТИ ПРИЛОЖЕНИЯ
// ==========================================

// void showExampleDialogs(BuildContext context) {
//   // 1. Простой диалог подтверждения удаления / опасного действия
//   showCustomDialog(
//     context: context,
//     type: DialogType.warning,
//     title: 'Удалить заказ?',
//     description:
//         'Вы действительно хотите отменить этот заказ? Это действие нельзя будет отменить.',
//     accentColor: const Color(0xFFE53E3E), // Красный цвет
//     primaryButtonText: 'Да, удалить',
//     onPrimaryPressed: () {
//       // Ваша логика удаления
//     },
//     secondaryButtonText: 'Отмена',
//   );

//   // 2. Уведомление об успехе
//   showCustomDialog(
//     context: context,
//     type: DialogType.success,
//     title: 'Заказ успешно создан!',
//     description:
//         'Номер вашего заказа #AU-24816. Вы можете отслеживать его в разделе "Заказы".',
//     primaryButtonText: 'Понятно',
//   );

//   // 3. Диалог с кастомным содержимым (например, поле ввода причины отмены)
//   showCustomDialog(
//     context: context,
//     type: DialogType.custom,
//     customIcon: Icons.edit_note_rounded,
//     title: 'Укажите причину',
//     description: 'Напишите комментарий к отмене заказа:',
//     customContent: const TextField(
//       maxLines: 3,
//       decoration: InputDecoration(
//         hintText: 'Введите причину...',
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(12)),
//         ),
//       ),
//     ),
//     primaryButtonText: 'Отправить',
//     onPrimaryPressed: () {
//       // Логика отправки комментария
//     },
//     secondaryButtonText: 'Закрыть',
//   );
// }
