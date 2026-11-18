import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_app_abbas/models/category_model.dart';
import 'package:evently_app_abbas/models/event_model.dart';
import 'package:evently_app_abbas/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  static Future<UserModel?> getCurrentUser(String uid) async {
    CollectionReference<Map<String, dynamic>> usersCollection =
        _getUsersCollectionReference();
    DocumentReference<Map<String, dynamic>> usersDocs = usersCollection.doc(
      uid,
    );
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await usersDocs.get();
    if (!documentSnapshot.exists || documentSnapshot.data() == null) {
      return null;
    }
    Map<String, dynamic> data = documentSnapshot.data()!;
    return UserModel.fromJson(data);
  }

  static Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<UserCredential?> signInWithGoogle() async {
    await GoogleSignIn.instance.initialize(
      serverClientId:
          '249340315739-m3ff47n74k3da51lumklbin7vgeg5bjc.apps.googleusercontent.com',
    );
    final GoogleSignInAccount googleUser =
        await GoogleSignIn.instance.authenticate();
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    UserModel? user = await getCurrentUser(userCredential.user!.uid);
    if (user == null) {
      user = UserModel(
        name: googleUser.displayName ?? '',
        id: userCredential.user!.uid,
        email: googleUser.email,
      );
      await addUserToFireStore(user);
    }
    UserModel.loggedInUser = user;
    return userCredential;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    UserModel.loggedInUser = null;
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
    UserModel? currentUser = UserModel.loggedInUser;
    if (currentUser == null) return;
    if (!currentUser.favEvents.contains(event.id)) {
      currentUser.favEvents.add(event.id);
    }
    CollectionReference<Map<String, dynamic>> usersCollection =
        _getUsersCollectionReference();
    DocumentReference<Map<String, dynamic>> userDoc =
        usersCollection.doc(currentUser.id);
    return userDoc.update({'favEvents': currentUser.favEvents});
  }

  static Future<void> removeEventFromFav(EventModel event) async {
    UserModel? currentUser = UserModel.loggedInUser;
    if (currentUser == null) return;
    currentUser.favEvents.remove(event.id);
    CollectionReference<Map<String, dynamic>> usersCollection =
        _getUsersCollectionReference();
    DocumentReference<Map<String, dynamic>> userDoc =
        usersCollection.doc(currentUser.id);
    return userDoc.update({'favEvents': currentUser.favEvents});
  }

  static Stream<List<EventModel>> getFavEventsRealTimeFromFireStore() {
    UserModel? currentUser = UserModel.loggedInUser;
    if (currentUser == null) return Stream.value([]);

    late StreamController<List<EventModel>> controller;
    StreamSubscription? userSub;
    StreamSubscription? eventsSub;

    void updateFavs() async {
      List<String> favIds = UserModel.loggedInUser?.favEvents ?? [];
      if (favIds.isEmpty) {
        if (!controller.isClosed) controller.add([]);
        return;
      }

      List<String> queryIds =
          favIds.length > 30 ? favIds.sublist(0, 30) : favIds;
      try {
        QuerySnapshot<Map<String, dynamic>> snap = await _getEventsCollectionReference()
            .where('id', whereIn: queryIds)
            .get();

        List<EventModel> events = snap.docs
            .map((doc) => EventModel.fromJson(doc.data()))
            .toList();

        events.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        if (!controller.isClosed) controller.add(events);
      } catch (e) {
        if (!controller.isClosed) controller.addError(e);
      }
    }

    controller = StreamController<List<EventModel>>(
      onListen: () {
        userSub = _getUsersCollectionReference()
            .doc(currentUser.id)
            .snapshots()
            .listen((userSnap) {
          if (userSnap.exists && userSnap.data() != null) {
            UserModel.loggedInUser = UserModel.fromJson(userSnap.data()!);
          }
          updateFavs();
        });

        eventsSub = _getEventsCollectionReference().snapshots().listen((_) {
          updateFavs();
        });
      },
      onCancel: () {
        userSub?.cancel();
        eventsSub?.cancel();
      },
    );

    return controller.stream;
  }

  static Future<void> deleteEvent(EventModel event) async {
    UserModel? currentUser = UserModel.loggedInUser;
    if (currentUser != null && currentUser.favEvents.contains(event.id)) {
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
    DocumentReference<Map<String, dynamic>> eventsDoc =
        eventsCollection.doc(event.id);
    return eventsDoc.update(event.toJson());
  }
}
