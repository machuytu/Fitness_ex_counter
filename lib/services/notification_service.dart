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
        .collection('users')
        .doc(_uid)
        .collection('notifications');
  }

  Future<void> addNotification(int id, String title, String message, int hour,
      int minute, List<int> listDaily) {
    return _ref
        .add(
          NotificationModel(
            idNotification: id,
            title: title,
            message: message,
            hour: hour,
            minute: minute,
            listDaily: listDaily,
            isOn: true,
          ).addJson(),
        )
        .then((value) => {print("Add Notification success")})
        .catchError((err) {
      print(err);
    });
  }

  Future<void> updateNotification(int id, String title, String message,
      int hour, int minute, List<int> listDaily) {
    return _ref
        .add(
          NotificationModel(
            idNotification: id,
            title: title,
            message: message,
            hour: hour,
            minute: minute,
            listDaily: listDaily,
            isOn: true,
          ).addJson(),
        )
        .then((value) => {print("Add Notification success")})
        .catchError((err) {
      print(err);
    });
  }

  Future<List<NotificationModel>> getNotificationByDay() {
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
