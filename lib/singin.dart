import 'package:flutter/material.dart';
class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  List<int> values = [1,2,3,4];
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(child: ListView(
        children: [
          for (int i =0;i<values.length;i++)
            Text('${values[i]}')
        ],
      )),

    );
  }
}
