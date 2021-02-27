import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'auth_service.dart';

class ExerciseCounterService {
  String _uid;
  String _excercise;
  DatabaseReference _excerciseCounterRef;

  ExerciseCounterService(String excercise) {
    var todayStr = DateFormat("yyyy-MM-dd").format(DateTime.now());
    _excercise = excercise;
    _uid = AuthService().getUser().uid;
    _excerciseCounterRef = FirebaseDatabase.instance
        .reference()
        .child('ExcerciseCounter')
        .child(_uid)
        .child(todayStr)
        .child(excercise);
  }

  void updateCounter(int incrementCounter) async {
    var counter = await getCounter();
    print('get UID: $_uid');
    print('get excercise: $_excercise');
    print('get incrementCounter: $incrementCounter');
    print('get counter: $counter');
    _excerciseCounterRef.set(counter + incrementCounter);
  }

  Future<int> getCounter() async {
    print('get UID: $_excercise');
    int value = (await _excerciseCounterRef.once()).value;
    return (value != null ? value : 0);
  }

  void getUID() {
    print('get UID: $_uid');
  }
}
