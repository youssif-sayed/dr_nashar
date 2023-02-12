import 'package:dr_nashar/home.dart';
import 'package:dr_nashar/resetpassword.dart';
import 'package:dr_nashar/signin.dart';
import 'package:dr_nashar/signup.dart';
import 'package:dr_nashar/resetpassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:video_player/video_player.dart';
import 'intro.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:chewie/chewie.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    home: const IntroScreen(),
    routes: {
      'Intro':(context) =>const IntroScreen(),
      'Sign in':(context) =>const SignIn(),
      'Sign up':(context) =>const SignUp(),
      'Reset Password' :(context) =>const ResetPassword(),
      'Home':(context) =>const home(),
},
    );
  }
}



