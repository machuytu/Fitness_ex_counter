import 'package:khoaluan/models/user.dart';

class ArgumentModel {
  User user;
  Function callback;
  String imageUrl;

  ArgumentModel({User user, Function callback, String imageUrl}) {
    this.user = user;
    this.callback = callback;
    this.imageUrl = imageUrl;
  }
}
