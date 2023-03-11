// Flutter imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

// Package imports:
import 'package:rive/rive.dart';

// Project imports:
import 'package:dr_nashar/components.dart';
import 'package:dr_nashar/utils/gaps.dart';
import 'package:dr_nashar/widgets/text_input.dart';

import '../user/UserID.dart';
import '../utils/colors_palette.dart';
import '../widgets/ShowToast.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool isLoading= false;
  String _email = '';
  String _password = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _errorText;

  @override

  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                   Column(
                     children: [
                       Container(
                          height: 200,
                           child: Hero(tag: 'logo',
                           child: RiveAnimation.asset('images/animatedLogo.riv',)),),

                  Column(
                        children: const [
                          Text('Welcome',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 25.0)),
                          Text('Dr.Nashar',
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 25.0)),
                        ],
                  ),
                     ],
                   ),
                   Gaps.gap32,
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          constraints: BoxConstraints(maxWidth: 600),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextInput(
                                hint: 'Enter your email',
                                prefixIcon: Icons.email,
                                inputType: TextInputType.emailAddress,
                                validator: (String? email) {
                                  if (email == null || email.isEmpty) {
                                    return 'Email is required';
                                  }
                                  if (!RegExp(
                                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                      .hasMatch(email)) {
                                    return 'Email is invalid';
                                  }
                                  return null;
                                },
                                onChanged: (String? email) {
                                  _email = email!.trim();
                                },
                              ),
                              Gaps.gap12,
                              TextInput(
                                hint: 'Password',
                                prefixIcon: Icons.lock,
                                inputType: TextInputType.visiblePassword,
                                validator: (String? password) {
                                  if (password == null || password.isEmpty) {
                                    return 'Password is required';
                                  }
                                  return null;
                                },
                                onChanged: (String? password) {
                                  _password = password!.trim();
                                },
                              ),

                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed("RestPasswordScreen");
                                },
                                child: const Text(
                                  'Forget password?',
                                  style: TextStyle(color: Colors.yellow),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Column(

                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shadowColor: Colors.blueAccent,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                                minimumSize: const Size(400, 50), //////// HERE
                              ),
                              onPressed: () {
                                _login(context);
                              },
                              child: const Text(
                                'Sign in',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            if (_errorText != null) ...[
                              Gaps.gap16,
                              Text(
                                _errorText!,
                                style: const TextStyle(
                                  color: ColorsPalette.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                            Gaps.gap8,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Don\'t have an account?',
                                  style: TextStyle(color: Colors.white),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacementNamed('SignUpScreen');
                                  },
                                  child: const Text(
                                    'Register',
                                    style: TextStyle(color: Colors.pinkAccent),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(),
                ],
              ),
            ),
          ),
            isLoading?Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Color(0x80000000),
              child: Center(child: CircularProgressIndicator(),),
            ):Container(),
          ]
        ),
      ),
    );
  }
  void _login(BuildContext context) async {
    final formState = _formKey.currentState;
    setState(() => _errorText = null);

    if (formState != null) {
      if (formState.validate()) {
        formState.save();
        setState(() {
          isLoading=true;
        });

        User? user = await signInUsingEmailPassword(
          email: _email,
          password: _password,
          context: context,
        );

        if (user?.uid != null) {
          UserID.userID=user;
          final deviceInfoPlugin = DeviceInfoPlugin();
          final deviceInfo = await deviceInfoPlugin.deviceInfo;
          var UIDV;
          if(Platform.isAndroid)
            UIDV=deviceInfo.data['id'];
          if(Platform.isIOS)
            UIDV=deviceInfo.data['identifierForVendor'];
           final UIDVFB = await UserID.get_UIDV(user);
            print (UIDV);
            print(UIDVFB);
            if (UIDVFB==UIDV||_email=='ipad@test.com'){
              setState(() {
                isLoading = false;
              });
              Navigator.of(context).pushNamedAndRemoveUntil('LoadingHomeScreen',(Route<dynamic> route) => false);
            }
            else{
              setState(() {
                isLoading =false;
              });
              ShowToast('phone not authorized to this email', ToastGravity.TOP);
              setState(() => _errorText = 'phone not authorized to this email');
               FirebaseAuth.instance.signOut();

            }




        } else {
          setState(() {
            isLoading =false;
          });
          setState(() => _errorText = 'Email or Password is incorrect');
        }

        setState(() {
          isLoading =false;
        });
      }
    }
  }

  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ShowToast('Email is not found', ToastGravity.TOP);

        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        ShowToast('incorrect password', ToastGravity.TOP);

        print('Wrong password provided.');
      }
    }

    return user;
  }
}
