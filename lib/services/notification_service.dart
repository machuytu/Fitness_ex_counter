import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khoaluan/models/notification_model.dart';

import 'auth_service.dart';

class NotificationService {
  CollectionReference _ref;
  String _uid;
  AuthService _auth = new AuthService();

  NotificationService() {
    _uid = _auth.getUser().uid;
    _ref = FirebaseFirestore.instance
        .collection('Users')
        .doc(_uid)
        .collection('Notifications');
  }

  Future<String> addNotification(
    int idNotification,
    String title,
    String message,
    int hour,
    int minute,
    List<int> listDaily,
  ) {
    return _ref
        .add(
      NotificationModel(
        idNotification: idNotification,
        title: title,
        message: message,
        hour: hour,
        minute: minute,
        listDaily: listDaily,
        isOn: true,
      ).addJson(),
    )
        .then((value) {
      print("Add Notification success ${value.id}");
      return value.id;
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> updateNotification(
    String id,
    int idNotification,
    String title,
    String message,
    int hour,
    int minute,
    List<int> listDaily,
    bool isOn,
  ) {
    return _ref
        .doc(id)
        .set(
          NotificationModel(
            title: title,
            message: message,
            hour: hour,
            minute: minute,
            listDaily: listDaily,
            isOn: isOn,
          ).updateJson(),
        )
        .then((value) => print("Notification Updated"))
        .catchError((err) {
      print(err);
    });
  }

  Future<void> deleteNotification(
    String id,
  ) {
    return _ref
        .doc(id)
        .delete()
        .then((value) => print("Notification Delete"))
        .catchError((err) {
      print(err);
    });
  }

  Future<List<NotificationModel>> getNotification() {
    return _ref
        .get()
        .then((querySnapshot) => querySnapshot.docs
            .map(
                (snapshot) => NotificationModel.fromFirestoreSnapshot(snapshot))
            .toList())
        .catchError((err) {
      print(err);
    });
  }
}
