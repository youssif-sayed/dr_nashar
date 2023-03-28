// Flutter imports:
import 'dart:async';
import 'dart:io' show Platform;

import 'package:dr_nashar/screens/NotificationsScreen.dart';
import 'package:dr_nashar/screens/assignment_screen.dart';
import 'package:dr_nashar/screens/home.dart';
import 'package:dr_nashar/screens/intro.dart';
import 'package:dr_nashar/screens/layout.dart';
import 'package:dr_nashar/screens/loadingHome.dart';
import 'package:dr_nashar/screens/loadingPay.dart';
import 'package:dr_nashar/screens/loadingSubject.dart';
import 'package:dr_nashar/screens/payScreen.dart';
import 'package:dr_nashar/screens/payVFcashScreen.dart';
import 'package:dr_nashar/screens/profileScreen.dart';
import 'package:dr_nashar/screens/quiz_screen.dart';

// Project imports:
import 'package:dr_nashar/screens/resetpassword.dart';
import 'package:dr_nashar/screens/signin.dart';
import 'package:dr_nashar/screens/signup.dart';
import 'package:dr_nashar/screens/subjectScreen.dart';
import 'package:dr_nashar/screens/videoScreen.dart';
import 'package:dr_nashar/shared/network/dio.dart';
import 'package:dr_nashar/user/UserID.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:chewie/chewie.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

// Project imports:
import 'package:dr_nashar/screens/resetpassword.dart';

import 'firebase_options.dart';
import 'dart:io' show Platform;

// Localization imports
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dr_nashar/l10n/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

ValueNotifier<String> language = ValueNotifier<String>('en');

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioHelperPayment.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FlutterDownloader.initialize();
  if (Platform.isAndroid)
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);

  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String token = '';

  void initState() {
    FirebaseMessaging.instance.getToken().then((value) {
      print('------------------------------');
      print('Token = $value');
      print('------------------------------');
      token = value ?? '';
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });

    // Receiving notifications>
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print(event.notification!.title);
      print(event.notification!.body);
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: language,
      builder: (context, lang, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          supportedLocales: L10n.all,
          locale: Locale(lang),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          initialRoute: FirebaseAuth.instance.currentUser != null
              ? 'LoadingHomeScreen'
              : 'Intro',
          home: IntroScreen(),
          routes: {
            'Intro': (context) => IntroScreen(),
            'SignInScreen': (context) => SignIn(),
            'SignUpScreen': (context) => SignUpScreen(),
            'RestPasswordScreen': (context) => ResetPassword(),
            'LoadingHomeScreen': (context) => LoadingHomeScreen(),
            'HomeScreen': (context) => HomeScreen(),
            'LoadingPayScreen': (context) => LoadingPayScreen(),
            'PayScreen': (context) => PayScreen(),
            'PayVFCashScreen': (context) => PayVFCashScreen(),
            'ProfileScreen': (context) => ProfileScreen(),
            'SubjectScreen': (context) => SubjectScreen(),
            'LoadingSubjectScreen': (context) => LoadingSubjectScreen(),
            // 'VideoScreen': (context) => VideoScreen(),
            'LayoutScreen': (context) => LayoutScreen(),
            'NotificationsScreen': (context) => NotificationsScreen(),
            // 'QuizScreen': (context) => QuizScreen(),
            // 'AssignmentScreen': (context) => AssignmentScreen(),
          },
        );
      },
    );
  }
}
