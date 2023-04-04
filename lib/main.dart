// Flutter imports:
import 'dart:async';
import 'dart:io' show Platform;

import 'package:dr_nashar/screens/NotificationsScreen.dart';
import 'package:dr_nashar/screens/home.dart';
import 'package:dr_nashar/screens/intro.dart';
import 'package:dr_nashar/screens/layout.dart';
import 'package:dr_nashar/screens/loadingHome.dart';
import 'package:dr_nashar/screens/loadingPay.dart';
import 'package:dr_nashar/screens/loadingSubject.dart';
import 'package:dr_nashar/screens/payRefScreen.dart';
import 'package:dr_nashar/screens/payScreen.dart';
import 'package:dr_nashar/screens/payVFcashScreen.dart';
import 'package:dr_nashar/screens/profileScreen.dart';

// Project imports:
import 'package:dr_nashar/screens/resetpassword.dart';
import 'package:dr_nashar/screens/signin.dart';
import 'package:dr_nashar/screens/signup.dart';
import 'package:dr_nashar/screens/subjectScreen.dart';
import 'package:dr_nashar/shared/network/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'firebase_options.dart';

// Localization imports
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dr_nashar/l10n/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'services/local_notifications/local_notifications_service.dart';

ValueNotifier<String> language = ValueNotifier<String>('en');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioHelperPayment.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FlutterDownloader.initialize();

  LocalNotificationsService.instance.init();

  if (Platform.isAndroid) {
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
          home: const IntroScreen(),
          routes: {
            'Intro': (context) => const IntroScreen(),
            'SignInScreen': (context) => const SignIn(),
            'SignUpScreen': (context) => const SignUpScreen(),
            'RestPasswordScreen': (context) => const ResetPassword(),
            'LoadingHomeScreen': (context) => const LoadingHomeScreen(),
            'HomeScreen': (context) => const HomeScreen(),
            'LoadingPayScreen': (context) => const LoadingPayScreen(),
            'PayScreen': (context) => const PayScreen(),
            'PayVFCashScreen': (context) => const PayVFCashScreen(),
            'ProfileScreen': (context) => const ProfileScreen(),
            'SubjectScreen': (context) => const SubjectScreen(),
            'LoadingSubjectScreen': (context) => const LoadingSubjectScreen(),
            // 'VideoScreen': (context) => VideoScreen(),
            'LayoutScreen': (context) => const LayoutScreen(),
            'NotificationsScreen': (context) => const NotificationsScreen(),
            'PayRefCodeScreen': (context) => const PayRefCodeScreen(),
            // 'QuizScreen': (context) => QuizScreen(),
            // 'AssignmentScreen': (context) => AssignmentScreen(),
          },
        );
      },
    );
  }
}
