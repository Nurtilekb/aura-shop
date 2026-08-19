import 'package:flutter/material.dart';

enum OrdersState { empty, noInternet, success }

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // Для теста можно менять состояние: OrdersState.empty или OrdersState.noInternet
  final OrdersState _currentState = OrdersState.empty;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Мои заказы',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _buildBody(colorScheme),
    );
  }

  Widget _buildBody(ColorScheme colorScheme) {
    switch (_currentState) {
      case OrdersState.empty:
        return EmptyStateWidget(
          image: _buildCircleAvatar(
            backgroundColor: colorScheme.surfaceContainerHighest,
            child: Center(child: Text('📦', style: TextStyle(fontSize: 50))),
          ),
          title: 'Заказов пока нет',
          subtitle:
              'Оформленные заказы будут появляться здесь вместе со статусом доставки.',
          buttonText: 'Начать покупки',
          onPressed: () {
            Navigator.pop(context);
          },
        );

      case OrdersState.noInternet:
        return Column(
          children: [
            Expanded(
              child: EmptyStateWidget(
                image: _buildCircleAvatar(
                  backgroundColor: colorScheme.primary.withValues(alpha: 0),
                  child: Icon(
                    Icons.cell_wifi,
                    size: 54,
                    color: colorScheme.error,
                  ),
                ),
                title: 'Нет соединения',
                subtitle:
                    'Не удалось загрузить данные. Проверьте интернет и повторите попытку.',
                buttonText: 'Повторить',
                buttonIcon: Icons.refresh,
                onPressed: () {
                  // TODO: Повторить запрос к Firestore
                },
              ),
            ),
            // Баннер ошибки Firestore внизу
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Firestore: не удалось получить данные (offline)',
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );

      case OrdersState.success:
        // TODO: Здесь будет список заказов из Firestore
        return const Center(child: Text('Список заказов'));
    }
  }

  Widget _buildCircleAvatar({
    required Color backgroundColor,
    required Widget child,
  }) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Center(child: child),
    );
  }
}

/// Переиспользуемый виджет состояния (DRY)
class EmptyStateWidget extends StatelessWidget {
  final Widget image;
  final String title;
  final String subtitle;
  final String buttonText;
  final IconData? buttonIcon;
  final VoidCallback onPressed;

  const EmptyStateWidget({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    this.buttonIcon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image,
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: 200,
              height: 48,
              child: ElevatedButton(
                onPressed: onPressed,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (buttonIcon != null) ...[
                      Icon(buttonIcon, size: 18),
                      const SizedBox(width: 8),
                    ],
                    Text(buttonText),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
