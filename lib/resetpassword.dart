import 'package:dr_nashar/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:dr_nashar/main.dart';
import 'package:dr_nashar/signin.dart';
import 'package:dr_nashar/resetpassword.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword>{

var emailController=TextEditingController();
var formkey=GlobalKey<FormState>();

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
                  const SizedBox(height: 150,),

                  const Text('Please enter your E-mail',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 25.0
                      )),

                  const SizedBox(height: 30,),

                  defaultFormField(controller: emailController,
                      type:TextEditingController(),
                      validate: (String? value){},
                      obscureText: false,
                      prefix: Icons.email,
                      lable: 'Student Email',
                      hintText: 'Student Email'
                  ),

                  const SizedBox(height: 10,),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
