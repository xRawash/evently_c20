import 'package:evently_app_abbas/core/sources/assets_manager.dart';
import 'package:evently_app_abbas/core/sources/colors_manager.dart';
import 'package:evently_app_abbas/l10n/app_localizations.dart';
import 'package:evently_app_abbas/providers/config_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    ConfigProvider configProvider = Provider.of<ConfigProvider>(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 38, horizontal: 8),
        child: Column(
          children: [
            Image.asset(ImageAssets.profilePic),
            SizedBox(height: 16,),
            Text("Muhammed Saad", style: Theme.of(context).textTheme.headlineMedium,)
            ,Text("moo@gmail.com", style: Theme.of(context).textTheme.labelSmall,)
          ,SizedBox(height: 32,),
            Card(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(AppLocalizations.of(context)!.darkMode, style: Theme.of(context).textTheme.labelMedium,),
                  Spacer(),
                  Switch(
                      activeColor: ColorsManager.blue,

                      value: configProvider.isDark, onChanged: (isDarkEnabled){
                        if(isDarkEnabled){
                          configProvider.changeAppTheme(ThemeMode.dark);
                        }else{
                          configProvider.changeAppTheme(ThemeMode.light);
                        }
                  })
                ],
              ),
            )),
            SizedBox(height: 16,),
            Card(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(AppLocalizations.of(context)!.language, style: Theme.of(context).textTheme.labelMedium,),
                  Spacer(),


                  DropdownButton(
                  icon: Icon(Icons.arrow_forward_ios_outlined),
                    underline: Container(),
                    items: [AppLocalizations.of(context)!.english, AppLocalizations.of(context)!.arabic].map((val)=>DropdownMenuItem(value: val,child: Text(val))).toList(),
                    onChanged: (newLang) {
                    if (newLang == AppLocalizations.of(context)!.english){
                      configProvider.changeAppLanguage('en');
                    } else {
                      configProvider.changeAppLanguage('ar');
                    }
;                    },
                  )


                ],
              ),
            )),
            SizedBox(height: 16,),
            Card(child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(AppLocalizations.of(context)!.logout, style: Theme.of(context).textTheme.labelMedium,),
                  Spacer(),


                Icon(Icons.logout)


                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
