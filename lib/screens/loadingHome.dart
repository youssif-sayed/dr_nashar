import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_nashar/user/yearsData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    user=  FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        UserID.userID = await FirebaseAuth.instance.currentUser;

        print(UserID.userID?.uid);
        print('User is signed in!');
        if (UserID.userID!=null) {
          final docRef =  FirebaseFirestore.instance.collection("userData").doc("${UserID.userID?.uid}");
          docRef.get().then(
                (DocumentSnapshot doc)  async {
              var data =  doc.data() as Map<String, dynamic>;
              if (data!=null) {
                print('data:$data');
                UserID.userdata = data;
                YearsData.set_defult_year();
                bool isyears = await YearsData.get_years_data();
                print(isyears);
                if (isyears)
                Navigator.of(context).pushReplacementNamed('HomeScreen');
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
    return const Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SpinKitDoubleBounce(color: Colors.amber,size: 100.0,),
        ),
      ),
    );
  }
}
