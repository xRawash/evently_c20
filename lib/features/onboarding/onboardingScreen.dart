import 'package:evently_app_abbas/core/sources/assets_manager.dart';
import 'package:evently_app_abbas/core/sources/colors_manager.dart';
import 'package:evently_app_abbas/core/sources/routes_manager.dart';
import 'package:evently_app_abbas/core/widgets/custom_elevted_button.dart';
import 'package:evently_app_abbas/features/onboarding/language_theme_settings.dart';
import 'package:evently_app_abbas/l10n/app_localizations.dart';
import 'package:evently_app_abbas/models/onboarding_model.dart';
import 'package:evently_app_abbas/prefs_manager/prefs_manager.dart';
import 'package:evently_app_abbas/providers/config_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lastPage = OnboardingModel.getOnboarding(context).length - 1;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Image(image: AssetImage(ImageAssets.eventlyLogo)),
        automaticallyImplyLeading: false,
        leading: _currentPage > 1
            ? IconButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                icon: Icon(Icons.arrow_back_ios_new),
                color: ColorsManager.darkBlue,
              )
            : null,
        actions: [
          if (_currentPage > 0 && _currentPage < lastPage)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: TextButton(
                onPressed: () => PrefsManager.finishedOnBoarding(context),
                child: Text(AppLocalizations.of(context)!.skip, style: TextStyle(
                  color: ColorsManager.darkBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              onPageChanged: (page){
                setState(() {
                  _currentPage = page;
                });
              },
              controller: _pageController,
              itemCount: OnboardingModel.getOnboarding(context).length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image(
                      image: AssetImage(
                        OnboardingModel.getOnboarding(context)[index].imagePath,
                      ),
                    ),
                    index > 0
                        ? Center(
                            child: AnimatedSmoothIndicator(
                              activeIndex: index - 1,
                              count: OnboardingModel.getOnboarding(context).length - 1,
                              effect: ExpandingDotsEffect(
                                activeDotColor: ColorsManager.darkBlue,
                                dotColor: ColorsManager.grey,
                                dotHeight: 8,
                                dotWidth: 8,
                                spacing: 8,
                              ),
                              onDotClicked: (dotIndex) {
                                _pageController.animateToPage(
                                  dotIndex + 1,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                          )
                        : SizedBox(),
                    SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        OnboardingModel.getOnboarding(context)[index].label(l10n),
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark ?  ColorsManager.white : ColorsManager.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      OnboardingModel.getOnboarding(context)[index].description(l10n),
                      style: Theme.of(context).textTheme.displayMedium,
                    ),

                    Spacer(),
                    index == 0
                        ? LanguageThemeSettings()
                        : SizedBox(),
                    SizedBox(height: 16,),
                    CustomElevatedButton(
                      title: index == 0
                          ? l10n.letsStart
                          : index == 3
                          ? l10n.getStarted
                          : l10n.next,
                      onPress: () {
                        index == 3
                            ? PrefsManager.finishedOnBoarding(context)
                            : _pageController.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
