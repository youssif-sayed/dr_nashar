// Flutter imports:
import 'dart:async';

import 'package:dr_nashar/screens/home.dart';
import 'package:dr_nashar/screens/intro.dart';
import 'package:dr_nashar/screens/loadingHome.dart';
import 'package:dr_nashar/screens/signin.dart';
import 'package:dr_nashar/screens/signup.dart';
import 'package:dr_nashar/shared/network/dio.dart';
import 'package:dr_nashar/user/UserID.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:chewie/chewie.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

// Project imports:
import 'package:dr_nashar/screens/resetpassword.dart';

import 'firebase_options.dart';
import 'dart:io'show Platform;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioHelperPayment.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if(Platform.isAndroid)
  FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);

  runApp( MyApp());
}


class MyApp extends StatefulWidget {


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserID())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
      initialRoute: FirebaseAuth.instance.currentUser!=null ?'LoadingHomeScreen':'Intro',
      home: IntroScreen(),
      routes: {
        'Intro':(context) =>IntroScreen(),
        'SignInScreen':(context) =>SignIn(),
        'SignUpScreen' :(context)=>SignUpScreen(),
        'RestPasswordScreen':(context)=>ResetPassword(),
        'LoadingHomeScreen':(context)=>LoadingHomeScreen(),
        'HomeScreen' :(context)=>HomeScreen(),

},
      ),
    );
  }


}



