import 'package:evently_app_abbas/models/category_model.dart';
import 'package:evently_app_abbas/models/event_model.dart';
import 'package:evently_app_abbas/repositories/contracts/event_repository.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  final EventRepository _eventRepository;

  HomeViewModel({required EventRepository eventRepository})
      : _eventRepository = eventRepository;

  CategoryModel? selectedCategory;

  void selectCategory(CategoryModel category) {
    selectedCategory = category;
    notifyListeners();
  }

  Stream<List<EventModel>> getEventsStream(CategoryModel category) {
    return _eventRepository.getEventsRealTimeFromFireStore(category);
  }

  Future<void> toggleFavorite(EventModel event) async {
    bool isFav = event.id.isNotEmpty &&
        (event.id == event.id);
    if (isFav) {
      await _eventRepository.removeEventFromFav(event);
    } else {
      await _eventRepository.addEventToFav(event);
    }
    notifyListeners();
  }
}
