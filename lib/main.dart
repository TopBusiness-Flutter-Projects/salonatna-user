import 'dart:io';
import 'package:app/models/businessLayer/global.dart';
import 'package:app/Theme/native_theme.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/provider/local_provider.dart';
import 'package:app/screens/splash_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    FirebaseApp? app;
    List<FirebaseApp> firebase = Firebase.apps;
    for (FirebaseApp appd in firebase) {
      if (appd.name == appName) {
        app = appd;
        break;
      }
    }
    if (app == null) {
        await Firebase.initializeApp();
    }
  } catch (e) {
    debugPrint('Exception - main.dart - _firebaseMessagingBackgroundHandler(): $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // uncomment the next line only if your SSL certificate is invalid
  // HttpOverrides.global = new MyHttpOverrides();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Can't initialize Firebase: $e");
  } finally {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
    runApp(const MyApp());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
  final String routeName = "main";

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/notificationdemo');
    var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      try {
        debugPrint('Got a message while in the foreground!');
        debugPrint('${message.data['0']}');
        debugPrint('Message data: ${message.data}');

        if (message.notification != null) {
          Future<String> downloadAndSaveFile(String url, String fileName) async {
            final Directory directory = await getApplicationDocumentsDirectory();
            final String filePath = '${directory.path}/$fileName';
            final http.Response response = await http.get(Uri.parse(url));
            final File file = File(filePath);
            await file.writeAsBytes(response.bodyBytes);
            return filePath;
          }

          if (Platform.isAndroid) {
            final String bigPicturePath = await downloadAndSaveFile(message.notification!.android!.imageUrl != null ? message.notification!.android!.imageUrl! : 'https://picsum.photos/200/300', 'bigPicture');

            final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
              FilePathAndroidBitmap(bigPicturePath),
            );
            final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(channel.id, channel.name, channelDescription: channel.description, icon: '@mipmap/notificationdemo', styleInformation: bigPictureStyleInformation);
            final AndroidNotificationDetails androidPlatformChannelSpecifics2 = AndroidNotificationDetails(channel.id, channel.name, channelDescription: channel.description, icon: '@mipmap/notificationdemo', styleInformation: BigTextStyleInformation(message.notification!.body!)
                );
            final NotificationDetails platformChannelSpecifics = NotificationDetails(android: message.notification!.android!.imageUrl != null ? androidPlatformChannelSpecifics : androidPlatformChannelSpecifics2);

            flutterLocalNotificationsPlugin.show(1, message.notification!.title, message.notification!.body, platformChannelSpecifics);
          } else if (Platform.isIOS) {
            final String bigPicturePath = await downloadAndSaveFile(message.notification!.apple!.imageUrl != null ? message.notification!.apple!.imageUrl! : 'https://picsum.photos/200/300', 'bigPicture.jpg');
            final DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails(attachments: <DarwinNotificationAttachment>[DarwinNotificationAttachment(bigPicturePath)]);
            const DarwinNotificationDetails iOSPlatformChannelSpecifics2 = DarwinNotificationDetails(badgeNumber: 1);
            final NotificationDetails notificationDetails = NotificationDetails(
              iOS: message.notification!.apple!.imageUrl != null ? iOSPlatformChannelSpecifics : iOSPlatformChannelSpecifics2,
            );
            await flutterLocalNotificationsPlugin.show(1, message.notification!.title, message.notification!.body, notificationDetails);
          }
        }

        if (message.notification != null) {
          debugPrint('Message also contained a notification: ${message.notification}');
        }
      } catch (e) {
        debugPrint('Exception - main.dart - onMessage.listen(): $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => LocaleProvider(),
        builder: (context, child) {
          final provider = Provider.of<LocaleProvider>(context);

          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Barber',
              navigatorObservers: <NavigatorObserver>[observer],
              theme: nativeTheme(),
              locale: provider.locale,
              supportedLocales: L10n.all,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              home: SplashScreen(
                a: analytics,
                o: observer,
              ));
        },
      );
}
