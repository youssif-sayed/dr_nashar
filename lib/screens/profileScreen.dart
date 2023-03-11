import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            ListTile(
              iconColor: Colors.red,
              textColor: Colors.red,
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil('Intro',(Route<dynamic> route) => false);
              },
              title: Text('Log out',style: TextStyle(fontSize: 20),),

              leading: Icon(Icons.logout_rounded),
            )
          ],
        ),
      ),
    );
  }
}
