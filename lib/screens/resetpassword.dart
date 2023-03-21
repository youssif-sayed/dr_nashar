// Flutter imports:
// Project imports:
import 'package:dr_nashar/utils/gaps.dart';
import 'package:dr_nashar/widgets/text_input.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/ShowToast.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  var emailController = TextEditingController();
  var formkey = GlobalKey<FormState>();
  String _email = '';
  String? msg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 150,
                  ),
                  const Text('Please enter your E-mail',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 25.0)),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: TextInput(
                      hint: 'Email',
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
                  ),
                  Gaps.gap24,
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shadowColor: Colors.blueAccent,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      minimumSize: const Size(400, 50),
                    ),
                    onPressed: () async {
                      await rest_password(context);
                    },
                    child: const Text(
                      'Rest password',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  if (msg != null) ...[
                    Gaps.gap16,
                    Text(
                      msg!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> rest_password(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
      ShowToast('password rest sent to email', ToastGravity.TOP);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          msg = 'Email is not found';
        });
      }
    }
  }
}
