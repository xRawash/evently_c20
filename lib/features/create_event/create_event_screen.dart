import 'package:evently_app_abbas/core/extensions/date_time_ex.dart';
import 'package:evently_app_abbas/core/sources/colors_manager.dart';
import 'package:evently_app_abbas/core/widgets/custom_elevted_button.dart';
import 'package:evently_app_abbas/core/widgets/custom_tab_bar.dart';
import 'package:evently_app_abbas/core/widgets/custom_text_form_field.dart';
import 'package:evently_app_abbas/core/widgets/cutom_text_button.dart';
import 'package:evently_app_abbas/l10n/app_localizations.dart';
import 'package:evently_app_abbas/models/category_model.dart';
import 'package:evently_app_abbas/view_models/event_form_view_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' show Fluttertoast, ToastGravity;
import 'package:provider/provider.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late FocusNode titleFocusNode;
  late FocusNode descriptionFocusNode;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    titleFocusNode = FocusNode();
    descriptionFocusNode = FocusNode();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    titleFocusNode.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }

  void _unfocusAll() {
    titleFocusNode.unfocus();
    descriptionFocusNode.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    EventFormViewModel eventFormViewModel = Provider.of<EventFormViewModel>(context);

    return GestureDetector(
      onTap: _unfocusAll,
      child: Scaffold(
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
                  child: Image.asset(eventFormViewModel.selectedCategory.image),
                ),
              ),
              const SizedBox(height: 16),
              CustomTabBar(
                categories: CategoryModel.categories,
                initialCategory: eventFormViewModel.selectedCategory,
                selectedBgColor: ColorsManager.darkBlue,
                selectedFgColor: ColorsManager.white,
                unSelectedBgColor: ColorsManager.white,
                unSelectedFgColor: ColorsManager.black,
                onSelectedCategoryClicked: (category) {
                  _unfocusAll();
                  eventFormViewModel.selectCategory(category);
                },
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.title,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                hintText: AppLocalizations.of(context)!.eventTitle,
                controller: titleController,
                focusNode: titleFocusNode,
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.description,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                hintText: AppLocalizations.of(context)!.eventDescription,
                lines: 4,
                controller: descriptionController,
                focusNode: descriptionFocusNode,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.date_range_outlined),
                  const SizedBox(width: 8),
                  Text(
                    eventFormViewModel.currentDateTime.toFormattedDate,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const Spacer(),
                  CustomTextButton(
                    text: AppLocalizations.of(context)!.chooseDate,
                    onTap: () => _chooseEventDate(eventFormViewModel),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.access_time),
                  const SizedBox(width: 8),
                  Text(
                    eventFormViewModel.currentDateTime.toFormattedTime,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const Spacer(),
                  CustomTextButton(
                    text: AppLocalizations.of(context)!.chooseTime,
                    onTap: () => _chooseEventTime(eventFormViewModel),
                  ),
                ],
              ),
              const Spacer(),
              eventFormViewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomElevatedButton(
                      title: AppLocalizations.of(context)!.addEvent,
                      onPress: () => _addEvent(eventFormViewModel),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _chooseEventDate(EventFormViewModel viewModel) async {
    _unfocusAll();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: viewModel.currentDateTime,
    );
    _unfocusAll();

    if (pickedDate != null) {
      viewModel.setDate(pickedDate);
    }
  }

  void _chooseEventTime(EventFormViewModel viewModel) async {
    _unfocusAll();
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: viewModel.currentTime,
    );
    _unfocusAll();

    if (pickedTime != null) {
      viewModel.setTime(pickedTime);
    }
  }

  void _addEvent(EventFormViewModel viewModel) async {
    _unfocusAll();
    final navigator = Navigator.of(context);
    bool success = await viewModel.createEvent(
      title: titleController.text,
      description: descriptionController.text,
    );
    if (!mounted) return;
    if (success) {
      Fluttertoast.showToast(
        msg: 'Event added successfully',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16,
      );
      navigator.pop();
    }
  }
}
