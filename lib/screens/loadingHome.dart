import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_nashar/user/yearsData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rive/rive.dart';

import '../user/UserID.dart';

class LoadingHomeScreen extends StatefulWidget {
  const LoadingHomeScreen({Key? key}) : super(key: key);

  @override
  State<LoadingHomeScreen> createState() => _LoadingHomeScreenState();
}

class _LoadingHomeScreenState extends State<LoadingHomeScreen> {
  @override
  late StreamSubscription<User?> user;
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    user = FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        UserID.userID = await FirebaseAuth.instance.currentUser;

        print(UserID.userID?.uid);
        print('User is signed in!');
        if (UserID.userID != null) {
          final docRef = FirebaseFirestore.instance
              .collection("userData")
              .doc("${UserID.userID?.uid}");
          docRef.get().then(
            (DocumentSnapshot doc) async {
              var data = doc.data() as Map<String, dynamic>;
              if (data != null) {
                print('data:$data');
                UserID.userdata = data;
                YearsData.set_defult_year();
                bool isyears = await YearsData.get_years_data();
                print(isyears);
                if (mounted) {
                  if (isyears) Navigator.of(context).pushReplacementNamed('LayoutScreen');
                }
              }
            },
            onError: (e) => print("Error getting document: $e"),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    user.cancel;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Container(
              height: 200,
              child: const Hero(
                  tag: 'logo',
                  child: RiveAnimation.asset(
                    'images/animatedLogo.riv',
                  )),
            ),
            Container(),
            Container(),
            const SpinKitRing(
              color: Colors.amber,
              size: 30.0,
              lineWidth: 3,
            ),
            Container(),
          ],
        ),
      ),
    );
  }
}
