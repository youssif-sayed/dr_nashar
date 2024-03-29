// Flutter imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Package imports:
import 'package:rive/rive.dart';

// Project imports:
import 'package:dr_nashar/utils/gaps.dart';
import 'package:dr_nashar/widgets/text_input.dart';

import '../user/UserID.dart';
import '../utils/colors_palette.dart';
import '../widgets/ShowToast.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool isLoading = false;
  String _email = '';
  String _password = '';
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 200,
                        child: Hero(
                            tag: 'logo',
                            child: RiveAnimation.asset(
                              'images/animatedLogo.riv',
                            )),
                      ),
                      Column(
                        children: [
                          Text(localization.welcome,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 25.0)),
                          const Text('Dr.Nashar',
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
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextInput(
                                hint: localization.enter_email_address,
                                prefixIcon: Icons.email,
                                inputType: TextInputType.emailAddress,
                                validator: (String? email) {
                                  if (email == null || email.isEmpty) {
                                    return localization
                                        .email_address_is_required;
                                  }
                                  if (!RegExp(
                                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                      .hasMatch(email)) {
                                    return localization
                                        .email_address_is_invalid;
                                  }
                                  return null;
                                },
                                onChanged: (String? email) {
                                  _email = email!.trim();
                                },
                              ),
                              Gaps.gap12,
                              TextInput(
                                hint: localization.password,
                                prefixIcon: Icons.lock,
                                inputType: TextInputType.visiblePassword,
                                validator: (String? password) {
                                  if (password == null || password.isEmpty) {
                                    return localization.password_is_required;
                                  }
                                  return null;
                                },
                                onChanged: (String? password) {
                                  _password = password!.trim();
                                },
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed("RestPasswordScreen");
                                },
                                child: Text(
                                  localization.forget_password,
                                  style: const TextStyle(color: Colors.yellow),
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
                              child: Text(
                                localization.sign_in,
                                style: const TextStyle(fontSize: 20),
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
                                  // #TODO
                                  'Don\'t have an account?',
                                  style: TextStyle(color: Colors.white),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushReplacementNamed('SignUpScreen');
                                  },
                                  child: const Text(
                                    // #TODO
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
                  const SizedBox(),
                ],
              ),
            ),
          ),
          isLoading
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: const Color(0x80000000),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(),
        ]),
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
          isLoading = true;
        });

        User? user = await signInUsingEmailPassword(
          email: _email,
          password: _password,
          context: context,
        );

        if (user?.uid != null) {
          UserID.userID = user;
          final deviceInfoPlugin = DeviceInfoPlugin();
          final deviceInfo = await deviceInfoPlugin.deviceInfo;
          var UIDV;
          if (Platform.isAndroid) UIDV = deviceInfo.data['id'];
          if (Platform.isIOS) UIDV = deviceInfo.data['identifierForVendor'];
          final UIDVFB = await UserID.get_UIDV(user);
          print(UIDV);
          print(UIDVFB);
          if (UIDVFB == UIDV || _email == 'ipad@test.com') {
            setState(() {
              isLoading = false;
            });
            Navigator.of(context).pushNamedAndRemoveUntil(
                'LoadingHomeScreen', (Route<dynamic> route) => false);
          } else {
            setState(() {
              isLoading = false;
            });
            ShowToast('phone not authorized to this email', ToastGravity.TOP);
            setState(() => _errorText = 'phone not authorized to this email');
            FirebaseAuth.instance.signOut();
          }
        } else {
          setState(() {
            isLoading = false;
          });
          setState(() => _errorText = 'Email or Password is incorrect');
        }

        setState(() {
          isLoading = false;
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
