// Flutter imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:dotted_border/dotted_border.dart';
import 'package:qr_flutter/qr_flutter.dart';


import '../user/UserID.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Container(
          height: 50,
          child: Hero(
              tag: 'logo',
              child: Image.asset(
                'images/Icon/appIcon.png',
              )),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: SafeArea(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("userData")
                .doc(UserID.userID?.uid)
                .snapshots(),
            builder: (context,snapshot){
              if (snapshot.hasData)
               {
                var DocData = snapshot.data as DocumentSnapshot;
                Map data = DocData.data() as Map<String, dynamic>;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xff08CE5D),
                            Color(0xff098FEA),
                          ],
                        ),),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 150,
                            padding: EdgeInsets.only(top: 30, left: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome,',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 35,fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${data['firstName']}',
                                  maxLines: 3,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 35,fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: QrImage(
                              data: "${UserID.userID?.uid}",
                              version: QrVersions.auto,
                              foregroundColor: Colors.white,

                              size: 150.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();

                        Navigator.of(context).pushReplacementNamed('Intro');
                      },
                      child: Text('logout'),
                    ),
                  ],
                ),
              );
              }
              else {return Center(child: CircularProgressIndicator());}
            }
          ),
        ),
      ),
    );
  }
}
