import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dr_nashar/main.dart';
import 'package:dr_nashar/components.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var fullnameController=TextEditingController();
  var emailController=TextEditingController();
  var studentmobilenumberController=TextEditingController();
  var parentjobController=TextEditingController();
  var fathermobilenumberController=TextEditingController();
  var mothermobilenumberController=TextEditingController();
  var cityController=TextEditingController();
  var passwordController=TextEditingController();
  var formkey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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

                defaultFormField(controller: fullnameController,
                    type:TextEditingController(),
                    validate: (String? value){
                      if(value!.isEmpty){
                        return 'Please enter student full name';
                      }
                      return null;
                    },
                    obscureText: false,
                    prefix: Icons.person,
                    lable: 'Student Full Name',
                    hintText: 'Student Full Name'
                ),

                const SizedBox(height: 30,),

                defaultFormField(controller: emailController,
                    type:TextEditingController(),
                    validate: (String? value){
                      if(value!.isEmpty){
                        return 'Please enter student email';
                      }
                      return null;
                    },
                    obscureText: false,
                    prefix: Icons.email,
                    lable: 'Student Email',
                    hintText: 'Student Email'
                ),

                const SizedBox(height: 30,),

                defaultFormField(controller: studentmobilenumberController,
                    type:TextEditingController(),
                    validate: (String? value){
                      if(value!.isEmpty){
                        return 'Please enter student mobile number';
                      }
                      return null;
                    },
                    obscureText: false,
                    prefix: Icons.phone_android_outlined,
                    lable: "Student Mobile Number",
                    hintText: "Student's Mobile number"
                ),

                const SizedBox(height: 30,),

                defaultFormField(controller: parentjobController,
                    type:TextEditingController(),
                    validate: (String? value){
                      if(value!.isEmpty){
                        return 'Please enter your parent job';
                      }
                      return null;
                    },
                    obscureText: false,
                    prefix: Icons.work,
                    lable: "Parent Job",
                    hintText: "Parent Job"
                ),

                const SizedBox(height: 30,),

                defaultFormField(controller: fathermobilenumberController,
                    type:TextEditingController(),
                    validate: (String? value){
                      if(value!.isEmpty){
                        return 'Please enter father mobile number';
                      }
                      return null;
                    },
                    obscureText: false,
                    prefix: Icons.phone_android_outlined,
                    lable: "Father Mobile Number",
                    hintText: "Father Mobile Number"
                ),

                const SizedBox(height: 30,),

                defaultFormField(controller: mothermobilenumberController,
                    type:TextEditingController(),
                    validate: (String? value){
                      if(value!.isEmpty){
                        return 'Please enter your mother mobile number';
                      }
                      return null;
                    },
                    obscureText: false,
                    prefix: Icons.phone_android_outlined,
                    lable: "Mother Mobile Number",
                    hintText: "Mother Mobile Number"
                ),

                const SizedBox(height: 30,),

                defaultFormField(controller: cityController,
                    type:TextEditingController(),
                    validate: (String? value){
                      if(value!.isEmpty){
                      return 'Please enter your city name';
                      }
                      return null;
                    },
                    obscureText: false,
                    prefix: Icons.location_city,
                    lable: "City",
                    hintText: "City"
                ),

                const SizedBox(height: 30,),

                defaultFormField(controller: passwordController,
                    type:TextEditingController(),
                    validate: (String? value){
                      if(value!.isEmpty){
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    prefix: Icons.password,
                    lable: "Password",
                    hintText: "Password", obscureText: false,
                ),

                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 50 , right: 50 ,),
                      child: GestureDetector(
                        onTap:(){

                        },
                        child: const CircleAvatar(
                          backgroundColor: Colors.brown,
                          radius: 50,
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10, left: 10 , right: 10 ,),
                      child: CircleAvatar(
                      backgroundColor: Colors.brown,
                      radius: 50,
                    ),
                    ),
                  ]
                ),

                const SizedBox(height: 10,),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shadowColor: Colors.blueAccent,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                    minimumSize: const Size(350, 50), //////// HERE
                  ),
                  onPressed: (){
                    Navigator.of(context).pushNamed('Sign in');
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(fontSize: 20),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 70,),
                  child: GestureDetector(
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account?",
                        style: const TextStyle(fontSize: 18, color: Colors.white,fontWeight: FontWeight.w700),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' Sign in',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(context, "Home");
                              },
                            style: const TextStyle(
                              color: Colors.green,
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
    );
  }
}
