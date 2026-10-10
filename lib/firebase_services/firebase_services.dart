import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_app_abbas/models/category_model.dart';
import 'package:evently_app_abbas/models/event_model.dart';
import 'package:evently_app_abbas/models/user_model.dart';

class FirebaseServices {
  static CollectionReference<Map<String, dynamic>>
  _getUsersCollectionReference() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    return db.collection('users');
  }

  static CollectionReference<Map<String, dynamic>>
  _getEventsCollectionReference() {
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

  static Stream<List<EventModel>> getEventsRealTimeFromFireStore(CategoryModel selectedCategory) async* {
    CollectionReference<Map<String, dynamic>> eventsCollection =
        _getEventsCollectionReference();
    Stream<QuerySnapshot<Map<String, dynamic>>> collectionSnapshots =
        eventsCollection.where('categoryId', isEqualTo: selectedCategory.id == '0' ? null : selectedCategory.id).snapshots();
    Stream<List<EventModel>> events = collectionSnapshots.map(
      (snapshot) =>
          snapshot.docs.map((doc) => EventModel.fromJson(doc.data())).toList(),
    );
    yield* events;
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
    UserModel currentUser = UserModel.loggedInUser!;

    return _getUsersCollectionReference()
        .doc(currentUser.id)
        .snapshots()
        .asyncExpand((userSnap) async* {
      if (!userSnap.exists || userSnap.data() == null) {
        yield [];
        return;
      }
      UserModel updatedUser = UserModel.fromJson(userSnap.data()!);
      UserModel.loggedInUser = updatedUser;

      if (updatedUser.favEvents.isEmpty) {
        yield [];
        return;
      }

      List<List<String>> chunks = [];
      for (var i = 0; i < updatedUser.favEvents.length; i += 30) {
        chunks.add(
          updatedUser.favEvents.sublist(
            i,
            i + 30 > updatedUser.favEvents.length
                ? updatedUser.favEvents.length
                : i + 30,
          ),
        );
      }

      yield* _getEventsCollectionReference()
          .where('id', whereIn: chunks[0])
          .snapshots()
          .map((snap) {
        List<EventModel> events =
            snap.docs.map((doc) => EventModel.fromJson(doc.data())).toList();
        events.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        return events;
      });
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
