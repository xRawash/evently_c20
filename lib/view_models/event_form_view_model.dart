import 'package:evently_app_abbas/models/category_model.dart';
import 'package:evently_app_abbas/models/event_model.dart';
import 'package:evently_app_abbas/models/user_model.dart';
import 'package:evently_app_abbas/repositories/contracts/event_repository.dart';
import 'package:flutter/material.dart';

class EventFormViewModel extends ChangeNotifier {
  final EventRepository _eventRepository;

  EventFormViewModel({required EventRepository eventRepository})
      : _eventRepository = eventRepository;

  DateTime currentDateTime = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();
  CategoryModel selectedCategory = CategoryModel.categories.first;
  bool isLoading = false;
  bool isInitialized = false;

  void initForUpdate(EventModel event) {
    if (!isInitialized) {
      selectedCategory = event.category;
      currentDateTime = event.dateTime;
      currentTime = TimeOfDay.fromDateTime(event.dateTime);
      isInitialized = true;
      notifyListeners();
    }
  }

  void selectCategory(CategoryModel category) {
    selectedCategory = category;
    notifyListeners();
  }

  void setDate(DateTime date) {
    currentDateTime = date.copyWith(
      hour: currentTime.hour,
      minute: currentTime.minute,
    );
    notifyListeners();
  }

  void setTime(TimeOfDay time) {
    currentTime = time;
    currentDateTime = currentDateTime.copyWith(
      hour: currentTime.hour,
      minute: currentTime.minute,
    );
    notifyListeners();
  }

  Future<bool> createEvent({
    required String title,
    required String description,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      EventModel event = EventModel(
        ownerId: UserModel.loggedInUser?.id ?? '',
        id: '',
        category: selectedCategory,
        title: title.trim(),
        description: description.trim(),
        dateTime: currentDateTime,
      );
      await _eventRepository.addEventToFireStore(event);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateEvent({
    required EventModel originalEvent,
    required String title,
    required String description,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      originalEvent.title = title.trim();
      originalEvent.description = description.trim();
      originalEvent.category = selectedCategory;
      originalEvent.dateTime = currentDateTime;

      await _eventRepository.updateEvent(originalEvent);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteEvent(EventModel event) async {
    isLoading = true;
    notifyListeners();

    try {
      await _eventRepository.deleteEvent(event);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
