import 'package:evently_app_abbas/data_sources/contracts/event_data_source.dart';
import 'package:evently_app_abbas/firebase_services/firebase_services.dart';
import 'package:evently_app_abbas/models/category_model.dart';
import 'package:evently_app_abbas/models/event_model.dart';

class EventFirestoreDataSourceImpl implements EventDataSource {
  @override
  Future<void> addEventToFireStore(EventModel event) {
    return FirebaseServices.addEventToFireStore(event);
  }

  @override
  Future<void> updateEvent(EventModel event) {
    return FirebaseServices.updateEvent(event);
  }

  @override
  Future<void> deleteEvent(EventModel event) {
    return FirebaseServices.deleteEvent(event);
  }

  @override
  Stream<List<EventModel>> getEventsRealTimeFromFireStore(
      CategoryModel selectedCategory) {
    return FirebaseServices.getEventsRealTimeFromFireStore(selectedCategory);
  }

  @override
  Stream<List<EventModel>> getFavEventsRealTimeFromFireStore() {
    return FirebaseServices.getFavEventsRealTimeFromFireStore();
  }

  @override
  Future<void> addEventToFav(EventModel event) {
    return FirebaseServices.addEventToFav(event);
  }

  @override
  Future<void> removeEventFromFav(EventModel event) {
    return FirebaseServices.removeEventFromFav(event);
  }
}
