import 'package:aurashop/widgets/profile_widgets/language_changer.dart';
import 'package:auto_route/auto_route.dart';
import 'package:aurashop/bloc/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<Color> _presetColors = [
    const Color(0xFF5b4bf0),
    const Color.fromRGBO(37, 99, 235, 1),
    const Color(0xFF159a6b),
    const Color(0xFFdf4a34),
    Colors.black,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          'Настройки',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
        systemOverlayStyle: Theme.of(context).brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('ТЕМА ОФОРМЛЕНИЯ'),
            const SizedBox(height: 12),
            _buildThemeModeSelector(),
            const SizedBox(height: 24),
            _buildSectionTitle('АКЦЕНТНЫЙ ЦВЕТ'),
            const SizedBox(height: 12),
            _buildColorGrid(),
            SizedBox(height: 12),
            _buildSectionTitle('ЯЗЫК'),
            const SizedBox(height: 12),
            _buildPreviewCard(),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionTitle('Push-уведомления'),
                Switch(
                  value: false,
                  onChanged: (bool? newValue) {
                    setState(() {});
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 15,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildThemeModeSelector() {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return SizedBox(
          child: Row(
            children: [
              Expanded(
                child: _buildThemeOption(
                  label: 'Светлая',
                  value: ThemeModeStatus.light,
                  currentValue: state.themeMode,
                ),
              ),
              Expanded(
                child: _buildThemeOption(
                  label: 'Темная',
                  value: ThemeModeStatus.dark,
                  currentValue: state.themeMode,
                ),
              ),
              Expanded(
                child: _buildThemeOption(
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
    required String label,
    required ThemeModeStatus value,
    required ThemeModeStatus currentValue,
  }) {
    final isSelected = value == currentValue;
    final activeColor = Theme.of(context).colorScheme.primary;
    final inactiveBorderColor = Theme.of(context).colorScheme.outlineVariant;
    final inactiveTextColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: () {
        context.read<ThemeCubit>().setThemeMode(value);
      },
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Карточка-превью с динамической обводкой
          Container(
            width: 90,
            height: 85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? activeColor : inactiveBorderColor,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: _buildThemePreview(value),
            ),
          ),
          const SizedBox(height: 8),
          // Подпись под карточкой
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? activeColor : inactiveTextColor,
            ),
          ),
        ],
      ),
    );
  }

  // Вспомогательный метод для генерации графического превью темы
  Widget _buildThemePreview(ThemeModeStatus mode) {
    switch (mode) {
      case ThemeModeStatus.light:
        return Container(
          color: const Color(0xFFF3F4F6),
          child: Center(
            child: Container(
              width: 40,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        );

      case ThemeModeStatus.dark:
        return Container(
          color: const Color(0xFF111827),
          child: Center(
            child: Container(
              width: 40,
              height: 58,
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        );

      case ThemeModeStatus.system:
        return Stack(
          children: [
            Row(
              children: [
                Expanded(child: Container(color: const Color(0xFFF3F4F6))),
                Expanded(child: Container(color: const Color(0xFF111827))),
              ],
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 20,
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(8),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 58,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1F2937),
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
    }
  }

  Widget _buildColorGrid() {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return SizedBox(
          height: 50,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),

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
                  width: 50,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(1000),
                    border: Border.all(color: Colors.transparent, width: 3),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(1000),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).scaffoldBackgroundColor
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(width: 12);
            },
          ),
        );
      },
    );
  }

  Widget _buildPreviewCard() {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return ProfileSettings(
          isDarkMode: false,
          onDarkModeChanged: (bool value) {},
        );
      },
    );
  }
}
