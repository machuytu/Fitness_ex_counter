import 'package:khoaluan/models/user.dart';

class ArgumentModel {
  User user;
  Function callback;

  ArgumentModel({User user, Function callback}) {
    this.user = user;
    this.callback = callback;
  }
}
