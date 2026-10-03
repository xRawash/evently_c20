import 'package:evently_app_abbas/core/sources/colors_manager.dart';
import 'package:evently_app_abbas/l10n/app_localizations.dart';
import 'package:evently_app_abbas/providers/config_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageThemeSettings extends StatelessWidget {
  const LanguageThemeSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfigProvider>(context);
    return Column(
      children: [
        Row(
          children: [
            Text(AppLocalizations.of(context)!.language, style: Theme.of(context).textTheme.displayLarge),
            Spacer(),
            _OptionButton(
              isSelected: config.currentLang == 'en',
              onTap: () {
                context.read<ConfigProvider>().changeAppLanguage("en");
              },
              label: AppLocalizations.of(context)!.english,
            ),
            SizedBox(width: 8),
            _OptionButton(
              isSelected: config.currentLang == 'ar',
              onTap: () {
                context.read<ConfigProvider>().changeAppLanguage("ar");
              },
              label: AppLocalizations.of(context)!.arabic,
            ),
          ],
        ),
        SizedBox(height: 16,),
        Row(
          children: [
            Text(AppLocalizations.of(context)!.theme, style: Theme.of(context).textTheme.displayLarge),
            Spacer(),
            _OptionButton(
              icon: Icons.light_mode_outlined,
              isSelected: config.currentTheme == ThemeMode.light,
              onTap: () => context.read<ConfigProvider>().changeAppTheme(ThemeMode.light),
            ),
            SizedBox(width: 8),
            _OptionButton(
              icon: Icons.dark_mode_outlined,
              isSelected: config.currentTheme == ThemeMode.dark,
              onTap: () => context.read<ConfigProvider>().changeAppTheme(ThemeMode.dark),
            ),
          ],
        ),
      ],
    );
  }
}

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    super.key,
    this.label,
    this.icon,
    required this.onTap,
    required this.isSelected,
  });

  final String? label;
  final IconData? icon;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final selectedColor = isSelected ? ColorsManager.white : ColorsManager.blue;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? ColorsManager.darkBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: ColorsManager.darkBlue),
        ),
        child: label != null
            ? Text(
                label!,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: selectedColor),
              )
            : Icon(icon, size: 20, color: selectedColor),
      ),
    );
  }
}
