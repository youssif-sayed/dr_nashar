import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserID with ChangeNotifier {
  static User? userID;
  static var db = FirebaseFirestore.instance;

  static Map<String, dynamic> userdata = {
    'firstName': '',
    'lastName': '',
    'fullName': '',
    'gender': '',
    'phone': '',
    'photo': '',
    'fatherPhone': '',
    'motherPhone': '',
    'parentJob': '',
    'gov': '',
    'grade': '',
    'school': '',
    'place': '',
    'email': '',
    'id': Random().nextInt(100000000).toString(),
    'UIDV': '',
  };

  static void push_user_data() async {
    db
        .collection("userData")
        .doc('${userID?.uid}')
        .set(userdata)
        .onError((e, _) => print("Error writing document: $e"));
  }

  static Future<void> get_user_data() async {
    final docRef = db.collection("userData").doc("${userID?.uid}");

    docRef.get().then(
      (DocumentSnapshot doc) async {
        final data = doc.data() as Map<String, dynamic>;
        userdata = data;
        print(userdata);
      },
      onError: (e) => print("Error getting document: $e"),
    );
    await Future.delayed(const Duration(seconds: 5));
    add_local_storage();
  }

  static Future<String> get_UIDV(user) async {
    print('UIDV user id : ${userID?.uid}');
    final docRef = await db.collection("userData").doc("${userID?.uid}").get();

    final data = docRef.data() as Map<String, dynamic>;
    final UIDV = data['UIDV'];

    return UIDV;
  }

  static Future<void> add_local_storage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('firstName', userdata['firstName']);
    prefs.setString('email', userdata['email']);
  }

  static Future<void> sign_out() async {
    await FirebaseAuth.instance.signOut();
  }
}
