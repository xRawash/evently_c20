import 'package:evently_app_abbas/core/sources/assets_manager.dart';
import 'package:evently_app_abbas/core/sources/colors_manager.dart';
import 'package:evently_app_abbas/core/widgets/custom_tab_bar.dart';
import 'package:evently_app_abbas/core/widgets/event_item.dart';
import 'package:evently_app_abbas/l10n/app_localizations.dart';
import 'package:evently_app_abbas/models/category_model.dart';
import 'package:evently_app_abbas/models/event_model.dart';
import 'package:evently_app_abbas/models/user_model.dart';
import 'package:evently_app_abbas/providers/config_provider.dart';
import 'package:evently_app_abbas/view_models/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    ConfigProvider configProvider = Provider.of<ConfigProvider>(context);
    HomeViewModel homeViewModel = Provider.of<HomeViewModel>(context);

    final allCategory = CategoryModel(
      id: "0",
      name: AppLocalizations.of(context)!.all,
      icon: Icons.all_inclusive,
      image: ImageAssets.meetingLight,
    );
    final currentCategory = homeViewModel.selectedCategory ?? allCategory;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.welcomeBack,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      UserModel.loggedInUser?.name ?? '',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    configProvider.changeAppTheme(
                      configProvider.isDark ? ThemeMode.light : ThemeMode.dark,
                    );
                  },
                  icon: configProvider.isDark
                      ? const Icon(Icons.light_mode_rounded)
                      : const Icon(Icons.dark_mode_rounded),
                ),
                const SizedBox(width: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 8,
                    ),
                    child: InkWell(
                      onTap: () {
                        configProvider.changeAppLanguage(
                          configProvider.isEnglish ? 'ar' : 'en',
                        );
                      },
                      child: Text(
                        configProvider.isEnglish ? 'AR' : 'EN',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            CustomTabBar(
              categories: [
                allCategory,
                ...CategoryModel.categories,
              ],
              initialCategory: currentCategory,
              onSelectedCategoryClicked: (category) {
                homeViewModel.selectCategory(category);
              },
              selectedBgColor: ColorsManager.darkBlue,
              selectedFgColor: ColorsManager.white,
              unSelectedBgColor: ColorsManager.white,
              unSelectedFgColor: ColorsManager.black,
            ),
            Expanded(
              child: StreamBuilder<List<EventModel>>(
                stream: homeViewModel.getEventsStream(currentCategory),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text("Something went wrong"));
                  }
                  List<EventModel> events = snapshot.data ?? [];
                  return ListView.separated(
                    padding: const EdgeInsets.only(top: 16),
                    itemBuilder: (context, index) =>
                        EventItem(event: events[index]),
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemCount: events.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
