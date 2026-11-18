import 'package:evently_app_abbas/models/event_model.dart';
import 'package:evently_app_abbas/repositories/contracts/event_repository.dart';
import 'package:flutter/material.dart';

class FavViewModel extends ChangeNotifier {
  final EventRepository _eventRepository;

  FavViewModel({required EventRepository eventRepository})
      : _eventRepository = eventRepository;

  String searchQuery = '';

  void setSearchQuery(String query) {
    searchQuery = query.trim().toLowerCase();
    notifyListeners();
  }

  Stream<List<EventModel>> getFavEventsStream() {
    return _eventRepository.getFavEventsRealTimeFromFireStore();
  }

  List<EventModel> filterEvents(List<EventModel> events) {
    if (searchQuery.isEmpty) return events;
    return events
        .where((event) => event.title.toLowerCase().contains(searchQuery))
        .toList();
  }

  Future<void> removeFavorite(EventModel event) async {
    await _eventRepository.removeEventFromFav(event);
    notifyListeners();
  }
}
