import 'package:evently_app_abbas/models/category_model.dart';
import 'package:evently_app_abbas/models/event_model.dart';

abstract class EventDataSource {
  Future<void> addEventToFireStore(EventModel event);
  Future<void> updateEvent(EventModel event);
  Future<void> deleteEvent(EventModel event);
  Stream<List<EventModel>> getEventsRealTimeFromFireStore(CategoryModel selectedCategory);
  Stream<List<EventModel>> getFavEventsRealTimeFromFireStore();
  Future<void> addEventToFav(EventModel event);
  Future<void> removeEventFromFav(EventModel event);
}
