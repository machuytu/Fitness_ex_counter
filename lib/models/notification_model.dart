import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String id;
  int idNotification;
  String title;
  String message;
  int hour;
  int minute;
  List<int> listDaily;

  NotificationModel({
    this.id,
    this.idNotification,
    this.title,
    this.message,
    this.hour,
    this.minute,
    this.listDaily,
  });

  @override
  String toString() =>
      'NotificationModel: ${this.id} / ${this.title} / ${this.message} / ${this.hour} -> ${this.minute}';

  factory NotificationModel.fromFirestoreSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data();
    data['id'] = snapshot.id;
    return NotificationModel.fromJson(data);
  }

  NotificationModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        idNotification = json['id_notification'],
        title = json['title'],
        message = json['message'],
        hour = json['hour'],
        minute = json['minute'],
        listDaily = (json['listDaily']).toList();

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'id_notification': this.idNotification,
        'title': this.title,
        'message': this.message,
        'hour': this.hour,
        'minute': this.minute,
        'listDaily': this.listDaily,
      };

  Map<String, dynamic> addJson() => {
        'id_notification': this.idNotification,
        'title': this.title,
        'message': this.message,
        'hour': this.hour,
        'minute': this.minute,
        'listDaily': this.listDaily,
      };

  Map<String, dynamic> updateJson() => {
        'title': this.title,
        'message': this.message,
        'hour': this.hour,
        'minute': this.minute,
        'listDaily': this.listDaily,
      };
}
