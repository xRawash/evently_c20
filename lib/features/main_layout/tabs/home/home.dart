import 'package:evently_app_abbas/core/sources/assets_manager.dart';
import 'package:evently_app_abbas/core/sources/colors_manager.dart';
import 'package:evently_app_abbas/core/widgets/custom_tab_bar.dart';
import 'package:evently_app_abbas/core/widgets/event_item.dart';
import 'package:evently_app_abbas/l10n/app_localizations.dart';
import 'package:evently_app_abbas/models/category_model.dart';
import 'package:evently_app_abbas/models/event_model.dart';
import 'package:evently_app_abbas/providers/config_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    ConfigProvider configProvider = Provider.of<ConfigProvider>(context);
    return Container(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.welcomeBack,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        "Muhammed Saad",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      configProvider.changeAppTheme(
                          configProvider.isDark ? ThemeMode.light : ThemeMode.dark);
                    },
                    icon: configProvider.isDark ? Icon(Icons.light_mode_rounded) : Icon(Icons.dark_mode_rounded),
                  ),
                  SizedBox(width: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 8,
                      ),
                      child: InkWell(
                        onTap: (){
                          configProvider.changeAppLanguage(configProvider.isEnglish ? 'ar' : 'en');
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
              SizedBox(height: 12),
              CustomTabBar(
                categories: [
                  CategoryModel(
                    id: "1",
                    name: AppLocalizations.of(context)!.all,
                    icon: Icons.all_inclusive,
                    image: ImageAssets.meetingLight,
                  ),
                  ...CategoryModel.getCategories(context),
                ],

                selectedBgColor: ColorsManager.darkBlue,
                selectedFgColor: ColorsManager.white,
                unSelectedBgColor: ColorsManager.white,
                unSelectedFgColor: ColorsManager.black,
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.only(top: 16),
                  itemBuilder: (context, index) => EventItem(
                    event: EventModel(
                      id: 1,
                      category: CategoryModel.getCategories(context)[0],
                      title: "Meeting for Updating The Development Method ",
                      description:
                          "Meeting for Updating The Development Method ",
                      date: DateTime.now(),
                      time: TimeOfDay.now(),
                    ),
                  ),
                  separatorBuilder: (context, index) => SizedBox(height: 8),
                  itemCount: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
