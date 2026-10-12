import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_app_abbas/models/category_model.dart';
import 'package:evently_app_abbas/models/event_model.dart';
import 'package:evently_app_abbas/models/user_model.dart';

class FirebaseServices {
  static CollectionReference<Map<String, dynamic>> _getUsersCollectionReference() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    return db.collection('users');
  }

  static CollectionReference<Map<String, dynamic>> _getEventsCollectionReference() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    return db.collection('Events');
  }

  static Future<void> addUserToFireStore(UserModel user) async {
    CollectionReference<Map<String, dynamic>> usersCollection =
        _getUsersCollectionReference();
    DocumentReference<Map<String, dynamic>> usersDoc = usersCollection.doc(
      user.id,
    );
    return usersDoc.set(user.toJson());
  }

  static Future<UserModel> getCurrentUser(String uid) async {
    CollectionReference<Map<String, dynamic>> usersCollection =
        _getUsersCollectionReference();
    DocumentReference<Map<String, dynamic>> usersDocs = usersCollection.doc(
      uid,
    );
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await usersDocs
        .get();
    Map<String, dynamic> data = documentSnapshot.data()!;
    return UserModel.fromJson(data);
  }

  static Future<void> addEventToFireStore(EventModel event) async {
    CollectionReference<Map<String, dynamic>> eventsCollection =
        _getEventsCollectionReference();
    DocumentReference<Map<String, dynamic>> eventsDoc = eventsCollection.doc();
    event.id = eventsDoc.id;
    return eventsDoc.set(event.toJson());
  }

  static Stream<List<EventModel>> getEventsRealTimeFromFireStore(
      CategoryModel selectedCategory) {
    Query<Map<String, dynamic>> query = _getEventsCollectionReference();
    if (selectedCategory.id != '0') {
      query = query.where('categoryId', isEqualTo: selectedCategory.id);
    }
    return query.snapshots().map((snapshot) {
      List<EventModel> events =
          snapshot.docs.map((doc) => EventModel.fromJson(doc.data())).toList();
      events.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      return events;
    });
  }
  static Future<void> addEventToFav(EventModel event) async {
    UserModel currentUser = UserModel.loggedInUser!;
    if (!currentUser.favEvents.contains(event.id)) {
      currentUser.favEvents.add(event.id);
    }
    CollectionReference<Map<String, dynamic>> usersCollection = _getUsersCollectionReference();
    DocumentReference<Map<String, dynamic>> userDoc = usersCollection.doc(currentUser.id);
    return userDoc.update({'favEvents': currentUser.favEvents});
  }

  static Future<void> removeEventFromFav(EventModel event) async {
    UserModel currentUser = UserModel.loggedInUser!;
    currentUser.favEvents.remove(event.id);
    CollectionReference<Map<String, dynamic>> usersCollection = _getUsersCollectionReference();
    DocumentReference<Map<String, dynamic>> userDoc = usersCollection.doc(currentUser.id);
    return userDoc.update({'favEvents': currentUser.favEvents});
  }

  static Stream<List<EventModel>> getFavEventsRealTimeFromFireStore() {
    List<String> favIds = UserModel.loggedInUser?.favEvents ?? [];

    if (favIds.isEmpty) {
      return Stream.value([]);
    }

    List<String> queryIds = favIds.length > 30 ? favIds.sublist(0, 30) : favIds;

    return _getEventsCollectionReference()
        .where('id', whereIn: queryIds)
        .snapshots()
        .map((snapshot) {
      List<EventModel> events = snapshot.docs
          .map((doc) => EventModel.fromJson(doc.data()))
          .toList();

      events.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      return events;
    });
  }

  static Future<void> deleteEvent(EventModel event) async {
    UserModel currentUser = UserModel.loggedInUser!;
    if (currentUser.favEvents.contains(event.id)) {
      currentUser.favEvents.remove(event.id);
      await _getUsersCollectionReference()
          .doc(currentUser.id)
          .update({'favEvents': currentUser.favEvents});
    }

    CollectionReference<Map<String, dynamic>> eventsCollection =
        _getEventsCollectionReference();
    return eventsCollection.doc(event.id).delete();
  }
  static Future<void> updateEvent(EventModel event) async {
    CollectionReference<Map<String, dynamic>> eventsCollection =
    _getEventsCollectionReference();
    DocumentReference<Map<String, dynamic>> eventsDoc = eventsCollection.doc(event.id);
    return eventsDoc.update(event.toJson());
  }
}
