import 'package:evently_app_abbas/data_sources/contracts/event_data_source.dart';
import 'package:evently_app_abbas/models/category_model.dart';
import 'package:evently_app_abbas/models/event_model.dart';
import 'package:evently_app_abbas/repositories/contracts/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  final EventDataSource _eventDataSource;

  EventRepositoryImpl({required EventDataSource eventDataSource})
      : _eventDataSource = eventDataSource;

  @override
  Future<void> addEventToFireStore(EventModel event) {
    return _eventDataSource.addEventToFireStore(event);
  }

  @override
  Future<void> updateEvent(EventModel event) {
    return _eventDataSource.updateEvent(event);
  }

  @override
  Future<void> deleteEvent(EventModel event) {
    return _eventDataSource.deleteEvent(event);
  }

  @override
  Stream<List<EventModel>> getEventsRealTimeFromFireStore(
      CategoryModel selectedCategory) {
    return _eventDataSource.getEventsRealTimeFromFireStore(selectedCategory);
  }

  @override
  Stream<List<EventModel>> getFavEventsRealTimeFromFireStore() {
    return _eventDataSource.getFavEventsRealTimeFromFireStore();
  }

  @override
  Future<void> addEventToFav(EventModel event) {
    return _eventDataSource.addEventToFav(event);
  }

  @override
  Future<void> removeEventFromFav(EventModel event) {
    return _eventDataSource.removeEventFromFav(event);
  }
}
