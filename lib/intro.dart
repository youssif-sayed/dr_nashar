import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'const/colors.dart';
import 'singin.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.blackColor,
      body: SafeArea(
        child: Center(
          child: Column(

            children:  [
              SizedBox(height: 30.0,),
              Image(image: AssetImage('images/IntroImage.png')),
              TextButton(onPressed: (){
                Navigator.of(context).pushNamed('Signin');
              }, child: Text('signin'))

            ],
          ),
        ),
      ),
    );
  }
}

