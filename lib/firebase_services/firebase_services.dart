import 'package:cloud_firestore/cloud_firestore.dart';
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

  // static Future<List<EventModel>> getEvent() async {
  //   CollectionReference<Map<String, dynamic>> eventsCollection =
  //       _getEventsCollectionReference();
  //   QuerySnapshot<Map<String, dynamic>> querySnapshot = await eventsCollection
  //       .get();
  //   List<DocumentSnapshot<Map<String, dynamic>>> documents = querySnapshot.docs;
  //   Map<String, dynamic> data = documents.first.data()!;
  //   return EventModel.fromJson(data);
  // }
}
