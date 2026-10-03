import 'dart:ui';

import 'package:evently_app_abbas/core/sources/assets_manager.dart';
import 'package:evently_app_abbas/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class OnboardingModel {
  final String Function(AppLocalizations) label;
  final String Function(AppLocalizations) description;
  final String imagePath;

  OnboardingModel({
    required this.label,
    required this.description,
    required this.imagePath,
  });

  static List<OnboardingModel> getOnboarding (
    BuildContext context,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      OnboardingModel(
        label: (l10n) => l10n.onboardingTitle1,
        description: (l10n) => l10n.onboardingDesc1,
        imagePath: isDark ? ImageAssets.onboardingDark1 : ImageAssets.onboarding1,
      ),
      OnboardingModel(
        label: (l10n) => l10n.onboardingTitle2,
        description: (l10n) => l10n.onboardingDesc2,
        imagePath: isDark? ImageAssets.onboardingDark2 : ImageAssets.onboarding2,
      ),
      OnboardingModel(
        label: (l10n) => l10n.onboardingTitle3,
        description: (l10n) => l10n.onboardingDesc3,
        imagePath: isDark? ImageAssets.onboardingDark3 : ImageAssets.onboarding3,
      ),
      OnboardingModel(
        label: (l10n) => l10n.onboardingTitle4,
        description: (l10n) => l10n.onboardingDesc4,
        imagePath: isDark? ImageAssets.onboardingDark4 : ImageAssets.onboarding4,
      ),
    ];
  }
}
