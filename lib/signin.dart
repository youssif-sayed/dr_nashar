import 'package:dr_nashar/utils/gaps.dart';
import 'package:dr_nashar/widgets/text_input.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dr_nashar/components.dart';
import 'package:rive/rive.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  String _email = '';
  String _password = '';

  @override

  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                     Container(
                        height: 200,
                         child: RiveAnimation.asset('images/animatedLogo.riv',),),
                    const SizedBox(
                      height: 10,
                    ),
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
                    Gaps.gap48,
                    Column(
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
                          onSaved: (String? email) {
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
                          onSaved: (String? password) {
                            _password = password!.trim();
                          },
                        ),
                        Gaps.gap8,
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed("Reset Password");
                          },
                          child: const Text(
                            'Forget password?',
                            style: TextStyle(color: Colors.yellow),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            Navigator.of(context).pushNamed('Home');
                          },
                          child: const Text(
                            'Sign in',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              'Don\'t have an account?',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextButton(
                              onPressed: () {},
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
            ),
          ),
        ),
      ),
    );
  }
}
