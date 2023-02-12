import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dr_nashar/components.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var emailController=TextEditingController();
  var passwordController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body:SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                children: [
                  const Image(image: AssetImage('images/Icon/appIcon.png'),
                    height: 200.0,
                    ),

                  const SizedBox(height: 10,),

                  const Text('Welcome',
                  style: TextStyle(
                      color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 30.0
                  )),

                  const Text('Dr.Nashar',
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w500,
                          fontSize: 30.0
                      )),

                  const SizedBox(height: 20,),
                  
                  defaultFormField(controller: emailController,
                      type:TextEditingController(),
                      validate: (String? value){},
                      obscureText: false,
                      prefix: Icons.email,
                      lable: 'Student Email',
                      hintText: 'Student Email'
                  ),

                  const SizedBox(height: 10,),

                  defaultFormField(controller: passwordController,
                      type:TextEditingController(),
                      validate: (String? value){},
                      obscureText: true,
                      prefix: Icons.password,
                      lable: "Password",
                      hintText: "Password"
                  ),

                  const SizedBox(height: 9,),

                  Padding(
                    padding: const EdgeInsets.only(left: 180,),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 18, color: Colors.yellow, fontWeight: FontWeight.w700),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Forget password?',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(context, "Reset Password");
                              },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30,),

                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shadowColor: Colors.blueAccent,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        minimumSize: const Size(400, 50), //////// HERE
                      ),
                      onPressed: (){
                        Navigator.of(context).pushNamed('Home');
                      },
                      child: const Text(
                          'Sign in',
                          style: TextStyle(fontSize: 20),
                      ),
                  ),

                  const SizedBox(height: 10,),

                  Padding(
                    padding: const EdgeInsets.only(right: 70,),
                    child: GestureDetector(
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account?",
                          style: const TextStyle(fontSize: 18, color: Colors.white,fontWeight: FontWeight.w700),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' Join Now',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(context, "Sign up");
                                },
                                style: const TextStyle(
                                  color: Colors.purple,
                                ),

                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
}
