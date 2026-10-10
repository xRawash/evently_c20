import 'package:evently_app_abbas/core/sources/colors_manager.dart';
import 'package:evently_app_abbas/core/widgets/custom_tab_bar.dart';
import 'package:evently_app_abbas/core/widgets/custom_text_form_field.dart';
import 'package:evently_app_abbas/firebase_services/firebase_services.dart';
import 'package:evently_app_abbas/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/extensions/date_time_ex.dart';
import '../../core/widgets/custom_elevted_button.dart';
import '../../core/widgets/cutom_text_button.dart';
import '../../l10n/app_localizations.dart';
import '../../models/event_model.dart';

class UpdateEvent extends StatefulWidget {
  const UpdateEvent({super.key});

  @override
  State<UpdateEvent> createState() => _UpdateEventState();
}

class _UpdateEventState extends State<UpdateEvent> {
  DateTime currentDateTime = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  CategoryModel selectedCategory = CategoryModel.categories.first;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(!isInitialized){
      final event = ModalRoute.of(context)!.settings.arguments as EventModel;
      titleController.text = event.title;
      descriptionController.text = event.description;
      selectedCategory = event.category;
      currentDateTime = event.dateTime;
      currentTime = TimeOfDay.fromDateTime(event.dateTime);
      isInitialized = true;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final event = ModalRoute.of(context)!.settings.arguments as EventModel;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.editEvent)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ColorsManager.grey, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.hardEdge,
                child: Image.asset(selectedCategory.image),
              ),
            ),
            SizedBox(height: 16),
            CustomTabBar(
              categories: CategoryModel.categories,
              initialCategory: selectedCategory,
              selectedBgColor: ColorsManager.darkBlue,
              selectedFgColor: ColorsManager.white,
              unSelectedBgColor: ColorsManager.white,
              unSelectedFgColor: ColorsManager.black,
              onSelectedCategoryClicked: (category) {
                setState(() {
                  selectedCategory = category;
                });
              },
            ),
            SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.title,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            SizedBox(height: 8),
            CustomTextFormField(
              hintText: AppLocalizations.of(context)!.eventTitle,
              controller: titleController,
            ),
            SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.description,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            SizedBox(height: 8),
            CustomTextFormField(
              hintText: AppLocalizations.of(context)!.eventDescription,
              lines: 4,
              controller: descriptionController,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.date_range_outlined),
                SizedBox(width: 8),
                Text(
                  currentDateTime.toFormattedDate,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Spacer(),
                CustomTextButton(
                  text: AppLocalizations.of(context)!.chooseDate,
                  onTap: _chooseEventDate,
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.access_time),
                SizedBox(width: 8),
                Text(
                  currentDateTime.toFormattedTime,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Spacer(),
                CustomTextButton(
                  text: AppLocalizations.of(context)!.chooseTime,
                  onTap: _chooseEventTime,
                ),
              ],
            ),

            Spacer(),
            CustomElevatedButton(
              title: AppLocalizations.of(context)!.updateEvent,
              onPress: () async {
                event.title = titleController.text;
                event.description = descriptionController.text;
                event.category = selectedCategory;
                event.dateTime = currentDateTime;
                await FirebaseServices.updateEvent(event);
                Fluttertoast.showToast(
                  msg: 'Event updated successfully',
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16,
                );
                if (mounted) Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _chooseEventDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      initialDate: currentDateTime,
    );

    if (pickedDate != null) {
      setState(() {
        currentDateTime = pickedDate.copyWith(
          hour: currentTime.hour,
          minute: currentTime.minute,
        );
      });
    }
  }

  void _chooseEventTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );

    if (pickedTime != null) {
      setState(() {
        currentTime = pickedTime;
        currentDateTime = currentDateTime.copyWith(
          hour: currentTime.hour,
          minute: currentTime.minute,
        );
      });
    }
  }
}
