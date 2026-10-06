import 'package:evently_app_abbas/core/extensions/date_time_ex.dart';
import 'package:evently_app_abbas/core/sources/assets_manager.dart';
import 'package:evently_app_abbas/core/sources/colors_manager.dart';
import 'package:evently_app_abbas/core/widgets/custom_elevted_button.dart';
import 'package:evently_app_abbas/core/widgets/custom_tab_bar.dart';
import 'package:evently_app_abbas/core/widgets/custom_text_form_field.dart';
import 'package:evently_app_abbas/core/widgets/cutom_text_button.dart';
import 'package:evently_app_abbas/firebase_services/firebase_services.dart';
import 'package:evently_app_abbas/l10n/app_localizations.dart';
import 'package:evently_app_abbas/models/category_model.dart';
import 'package:evently_app_abbas/models/event_model.dart';
import 'package:evently_app_abbas/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' show Fluttertoast, ToastGravity;

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  DateTime currentDateTime = DateTime.now();

  /// 14-9-2026 - 6:012

  /// 14-9-2026 , 6:01:00:000
  TimeOfDay currentTime = TimeOfDay.now();
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  CategoryModel? selectedCategory;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    selectedCategory ?? CategoryModel.categories.first;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.addEvent)),
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
                child: Image.asset(selectedCategory?.image ?? CategoryModel.categories[0].image),
              ),
            ),
            SizedBox(height: 16),
            CustomTabBar(
              categories: CategoryModel.categories,
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
                Icon(Icons.date_range_outlined),
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
              title: AppLocalizations.of(context)!.addEvent,
              onPress: () {
                _addEvent();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _chooseEventDate() async {
    currentDateTime =
        await showDatePicker(
          context: context,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
          initialDate: DateTime.now(),
        ) ??
        currentDateTime;

    currentDateTime = currentDateTime.copyWith(
      hour: currentTime.hour,
      minute: currentTime.minute,
    );
    setState(() {});
  }

  void _chooseEventTime() async {
    currentTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now()) ??
        currentTime;

    currentDateTime = currentDateTime.copyWith(
      hour: currentTime.hour,
      minute: currentTime.minute,
    );
    setState(() {});
  }

  void _addEvent() async {
    EventModel event = EventModel(
      ownerId: UserModel.loggedInUser!.id,
      id: '',
      category: selectedCategory!,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      dateTime: currentDateTime,
    );
    await FirebaseServices.addEventToFireStore(event);
    Fluttertoast.showToast(
      msg: 'Event added successfully',
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16,
    );
    Navigator.pop(context);
  }
}
