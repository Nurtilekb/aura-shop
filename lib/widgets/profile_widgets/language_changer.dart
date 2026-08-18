import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSettings extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;

  const ProfileSettings({
    super.key,
    required this.isDarkMode,
    required this.onDarkModeChanged,
  });

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  String selectedLanguage = '🇷🇺 Русский';

  final List<Map<String, String>> languages = [
    {'flag': '🇺🇸', 'name': 'English', 'code': 'en'},
    {'flag': '🇷🇺', 'name': 'Русский', 'code': 'ru'},
    {'flag': '🇰🇬', 'name': 'Кыргызча', 'code': 'ky'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // 👈 исправлено
        border: Border.all(color: Colors.grey.shade400, width: 0.7),
      ),
      child: Column(
        children: [
          for (int i = 0; i < languages.length; i++)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: BuiltLangItem(
                    key: ValueKey(languages[i]['code']),
                    text: '${languages[i]['flag']} ${languages[i]['name']}',
                    currentSelected: selectedLanguage,
                    onTap: () {
                      setState(() {
                        selectedLanguage =
                            '${languages[i]['flag']} ${languages[i]['name']}';
                      });
                    },
                  ),
                ),
                if (i < languages.length - 1)
                  Divider(height: 0, color: Colors.grey.shade400),
              ],
            ),
        ],
      ),
    );
  }
}

class BuiltLangItem extends StatelessWidget {
  final String text;
  final String currentSelected;
  final VoidCallback onTap;

  const BuiltLangItem({
    super.key,
    required this.text,
    required this.currentSelected,
    required this.onTap,
  });

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (_initializedLanguage) return;
  //   selectedLanguage = _languageLabelForCode(context.locale.languageCode);
  //   _initializedLanguage = true;
  // }

  // String _languageLabelForCode(String code) {
  //   for (final lang in languages) {
  //     if (lang['code'] == code) {
  //       return '${lang['flag']} ${lang['name']}';
  //     }
  //   }
  //   return '🇷🇺 Русский';
  // }

  // Future<void> _saveLanguage(String code) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('selected_language_code', code);
  //   await prefs.setString('selected_language', _languageLabelForCode(code));
  // }

  @override
  Widget build(BuildContext context) {
    final isSelected = currentSelected == text;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          height: 60,

          child: Row(
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.purple.shade700 : Colors.black,
                ),
              ),
              const Spacer(),
              if (isSelected)
                Icon(Icons.check, size: 20, color: Colors.purple.shade700),
            ],
          ),
        ),
      ),
    );
  }
}
