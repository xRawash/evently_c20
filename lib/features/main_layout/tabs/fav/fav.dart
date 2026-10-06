import 'package:evently_app_abbas/core/widgets/custom_text_form_field.dart';
import 'package:evently_app_abbas/core/widgets/event_item.dart';
import 'package:evently_app_abbas/l10n/app_localizations.dart';
import 'package:evently_app_abbas/models/category_model.dart';
import 'package:evently_app_abbas/models/event_model.dart';
import 'package:flutter/material.dart';

class Favourite extends StatelessWidget {
  const Favourite({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomTextFormField(hintText: AppLocalizations.of(context)!.searchForEvent, suffixIcon: Icon(Icons.search),),
            // Expanded(child: ListView.separated(
            //   padding: EdgeInsets.only(top: 16),
            //     itemBuilder: (context,index)=>EventItem(event: EventModel(id: "1", category: CategoryModel.categories[0], title: "Meeting for Updating The Development Method ", description: "Meeting for Updating The Development Method ", dateTime: DateTime.now(),)),
            //     separatorBuilder: (context, index)=>SizedBox(height: 8,),
            //     itemCount: 20))
          ],
        ),
      ),
    );
  }
}
