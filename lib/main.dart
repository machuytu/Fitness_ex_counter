import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:khoaluan/screens/info_screen.dart';
import 'package:khoaluan/screens/info_user.dart';
import 'package:khoaluan/screens/login_screen.dart';
import 'package:khoaluan/screens/register_screen.dart';
import 'package:khoaluan/screens/splash_screen.dart';
import 'package:khoaluan/screens/update_account.dart';
import 'package:khoaluan/widgets/bottomnav.dart';
import 'package:khoaluan/screens/notification_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'models/receive_notification.dart';

const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

String selectedNotificationPayload;

List<CameraDescription> cameras;
Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // available cameras
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }

  // permission notification
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          onDidReceiveLocalNotification:
              (int id, String title, String body, String payload) async {
            didReceiveLocalNotificationSubject.add(ReceivedNotification(
                id: id, title: title, body: body, payload: payload));
          });
  const MacOSInitializationSettings initializationSettingsMacOS =
      MacOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false);
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    selectedNotificationPayload = payload;
    selectNotificationSubject.add(payload);
  });

  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BuildContext contextMain;
  @override
  void initState() {
    super.initState();
    _configureSelectNotificationSubject();
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      if (payload == "x") {
        Get.toNamed('/login');
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    contextMain = context;
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return CircularProgressIndicator();
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Fitness counter',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              initialRoute: "/splash",
              routes: {
                "/notification": (context) => NotificationScreen(),
                "/": (context) => BottomNav(cameras: cameras),
                "/splash": (context) => SplashScreen(),
                "/login": (context) => LoginScreen(),
                "/register": (context) => ResigterScreen(),
                "/info_user": (context) => InfoUser(),
                "/info_screen": (context) => InfoScreen(),
                "/update_account": (context) => UpdateAccount(),
              },
            );
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return CircularProgressIndicator();
        });
  }
}
