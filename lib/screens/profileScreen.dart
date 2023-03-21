import 'package:dr_nashar/components.dart';
import 'package:dr_nashar/screens/student_marks_screen.dart';
import 'package:dr_nashar/user/UserID.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../user/yearsData.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20.0,
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 80,
                  width: 150,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xff08CE5D),
                          Color(0xff098FEA),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Image.asset(UserID.userdata['gender'] == 'male'
                      ? 'images/male.png'
                      : 'images/female.png'),
                ),
                const SizedBox(width: 15.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10.0),
                    Text(
                      UserID.userdata['firstName'] +
                          ' ' +
                          UserID.userdata['lastName'],
                      style: const TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      UserID.userdata['grade'],
                      style: const TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
              ],
            ),

            const SizedBox(
              height: 30.0,
            ),

            const Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),

            const SizedBox(
              height: 10.0,
            ),

            // Email
            userInfo(
              Icons.view_headline_sharp,
              'Marks',
              const Color(0xff098FEA),
              () {
                showLoadingDialog(context);
                YearsData.getStudentMarks().then((value) {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const StudentMarksScreen()));
                });
              },
            ),

            const SizedBox(height: 15.0),

            userInfo(
              Icons.language,
              'Language',
              Colors.green,
              () {},
            ),

            const SizedBox(height: 15.0),

            userInfo(
              Icons.phone_android_outlined,
              'Logout',
              Colors.red,
              () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    'Intro', (Route<dynamic> route) => false);
              },
            ),

            const SizedBox(height: 15.0),

            // userInfo(
            //   Icons.place_rounded,
            //   UserID.userdata['place'],
            // ),

            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
