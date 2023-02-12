import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'const/colors.dart';
import 'package:dr_nashar/signin.dart';
import 'package:dotted_border/dotted_border.dart';
class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            DottedBorder(
              color: Colors.blueAccent,
              strokeWidth: 3,
              borderType: BorderType.Circle,
              radius: const Radius.circular(110),
              padding: const EdgeInsets.all(10),
              dashPattern: const [20,10 ],
              child: const CircleAvatar(
                radius: 100,
                backgroundColor: Colors.white,
                child: Image(image: AssetImage('images/Rectangle_14-removebg-preview 1.png')),
              ),
            ),
            const SizedBox(height: 40.0),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
              style: TextStyle(fontSize: 30, color: Colors.white, fontStyle: FontStyle.normal),
              children: <TextSpan>[
                TextSpan(text: 'Start studying math today',
                    style:
                    TextStyle(
                        fontWeight: FontWeight.w300
                    ),
                ),
              ],
            ),),

            const SizedBox( height: 40.0),

            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shadowColor: Colors.blueAccent,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  minimumSize: const Size(400, 55), //////// HERE
                ),

                onPressed: (){
              Navigator.of(context).pushNamed('Sign in');
            },
                child: const Text(
                    'Sign in',
                  style: TextStyle(fontSize: 20),
                )
            ),

            const SizedBox( height: 5.0),

            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape:
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  minimumSize: const Size(400, 55), //////// HERE
                ),

                onPressed: (){
                  Navigator.of(context).pushNamed('Sign up');
                },
                child: const Text(
                    'Sign up',
                  style: TextStyle(fontSize: 20),
                )
            ),
          ],
        ),
      ),
    );
  }
}

