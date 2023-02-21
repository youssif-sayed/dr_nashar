// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dotted_border/dotted_border.dart';

// Project imports:
import 'package:dr_nashar/utils/gaps.dart';
import 'package:dr_nashar/utils/gredientText.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DottedBorder(
                    color: Colors.blueAccent,
                    strokeWidth: 3,
                    borderType: BorderType.Circle,
                    radius: const Radius.circular(110),
                    padding: const EdgeInsets.all(10),
                    dashPattern: const [20, 0],
                    child: const CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.white,
                      child: Image(
                          image: AssetImage(
                              'images/Rectangle_14-removebg-preview 1.png')),
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  GradientText(
                    'Start studying math today',
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                    gradient: LinearGradient(colors: [
                      Color(0xff08CE5D),
                      Color(0xff098DEF),
                    ]),
                  ),

                  const SizedBox(height: 40.0),
                  Column(
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shadowColor: Colors.blueAccent,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                            minimumSize: const Size(400, 55),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed('SignInScreen');
                          },
                          child: const Text(
                            'Sign in',
                            style: TextStyle(fontSize: 20),
                          )),
                      Gaps.gap12,
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('SignUpScreen');
                          },
                          child: Text(
                            'Sign up',
                            style: TextStyle(fontSize: 20),
                          ))
                    ],
                  ),
                  const SizedBox(height: 5.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
