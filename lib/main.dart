import 'package:battery/battery.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.light;

  static const String BATTERY_NOTIFICATION_CHANNEL_ID = "battery_notification";
  static const String INTERNET_NOTIFICATION_CHANNEL_ID = "internet_notification";

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initNotifs();
    initConnectivity();
    initBattery();
  }

  void initNotifs() async {
    var initializationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void initConnectivity() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      print("Connectivity status: $result");
      final hasInternet = result != ConnectivityResult.none;
      if (hasInternet) {
        showNotification(
          title: 'Internet Connection',
          body: 'You are now connected to the internet!',
          channelId: INTERNET_NOTIFICATION_CHANNEL_ID,
        );
      } else {
        showNotification(
          title: 'No Internet Connection',
          body: 'You are not connected to the internet!',
          channelId: INTERNET_NOTIFICATION_CHANNEL_ID,
        );
      }
    });
  }

  void initBattery() {
    final battery = Battery();
    battery.onBatteryStateChanged.listen((BatteryState state) {
      if (state == BatteryState.charging) {
        battery.batteryLevel.then((level) {
          if (level != null && level >= 80) {
            showNotification(
              title: 'Battery health',
              body:
              'Battery level is now $level%, please unplug your charger for battery maintenance.',
              channelId: BATTERY_NOTIFICATION_CHANNEL_ID,
            );
          }
        });
      }
    });
  }

  void showNotification({
    required String title,
    required String body,
    required String channelId,
  }) {
    flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: themeMode == ThemeMode.light
          ? ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      )
          : ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: HomeScreen(
        onThemeChanged: (themeMode) {
          setState(() {
            this.themeMode = themeMode;
          });
        },
      ),
    );
  }
}
