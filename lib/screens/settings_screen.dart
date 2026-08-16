import 'package:aurashop/theme/app_colors.dart';
import 'package:auto_route/auto_route.dart';
import 'package:aurashop/bloc/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Предопределенные цвета для выбора
  final List<Color> _presetColors = [
    const Color(0xFF5D50FE), // Фиолетовый (основной)
    const Color(0xFF2196F3), // Синий
    const Color(0xFF4CAF50), // Зеленый
    const Color(0xFFFF9800), // Оранжевый
    const Color(0xFFF44336), // Красный
    const Color(0xFF9C27B0), // Пурпурный
    const Color(0xFF00BCD4), // Бирюзовый
    const Color(0xFFE91E63), // Розовый
    const Color(0xFF795548), // Коричневый
    const Color(0xFF607D8B), // Серо-синий
    const Color(0xFF3F51B5), // Индиго
    const Color(0xFF009688), // Бирюзово-зеленый
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Тема оформления'),
            const SizedBox(height: 12),
            _buildThemeModeSelector(),
            const SizedBox(height: 24),
            _buildSectionTitle('Основной цвет (Seed Color)'),
            const SizedBox(height: 12),
            Text(
              'Выберите цвет для кастомизации всех виджетов',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            _buildColorGrid(),
            const SizedBox(height: 24),
            _buildSectionTitle('Предпросмотр'),
            const SizedBox(height: 12),
            _buildPreviewCard(),
            const SizedBox(height: 32),
            _buildCurrentColorInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildThemeModeSelector() {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildThemeOption(
                  icon: Icons.light_mode_outlined,
                  label: 'Светлая',
                  value: ThemeModeStatus.light,
                  currentValue: state.themeMode,
                ),
              ),
              Expanded(
                child: _buildThemeOption(
                  icon: Icons.dark_mode_outlined,
                  label: 'Темная',
                  value: ThemeModeStatus.dark,
                  currentValue: state.themeMode,
                ),
              ),
              Expanded(
                child: _buildThemeOption(
                  icon: Icons.brightness_auto_outlined,
                  label: 'Системная',
                  value: ThemeModeStatus.system,
                  currentValue: state.themeMode,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption({
    required IconData icon,
    required String label,
    required ThemeModeStatus value,
    required ThemeModeStatus currentValue,
  }) {
    final isSelected = value == currentValue;
    return InkWell(
      onTap: () {
        context.read<ThemeCubit>().setThemeMode(value);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorGrid() {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemCount: _presetColors.length,
          itemBuilder: (context, index) {
            final color = _presetColors[index];
            final isSelected = color.toARGB32() == state.seedColor.toARGB32();
            return InkWell(
              onTap: () {
                context.read<ThemeCubit>().setSeedColor(color);
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onSurface
                        : Colors.transparent,
                    width: 3,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.onSurface,
                      )
                    : null,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPreviewCard() {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final previewColors = AppColors.light(state.seedColor);
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Кнопка
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: previewColors.primary,
                      foregroundColor: previewColors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Кнопка'),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Поле ввода',
                    filled: true,
                    fillColor: previewColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: previewColors.outlineVariant,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: previewColors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(
                      label: const Text('Primary'),
                      backgroundColor: previewColors.primary,
                      labelStyle: TextStyle(color: previewColors.onPrimary),
                    ),
                    Chip(
                      label: const Text('Secondary'),
                      backgroundColor: previewColors.secondary,
                      labelStyle: TextStyle(color: previewColors.onSecondary),
                    ),
                    Chip(
                      label: const Text('Tertiary'),
                      backgroundColor: previewColors.tertiary,
                      labelStyle: TextStyle(color: previewColors.onTertiary),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: 0.7,
                  backgroundColor: previewColors.primaryContainer,
                  color: previewColors.primary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrentColorInfo() {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Текущий цвет',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: state.seedColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '#${state.seedColor.toARGB32().toRadixString(16).toUpperCase().padLeft(8, '0')}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          'Seed Color',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
