import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (Rect bounds) => LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff08CE5D),
                  Color(0xff098FEA),
                ],
              ).createShader(bounds),
              child: IconButton(onPressed: (){
                Navigator.pushNamed(context, 'ProfileScreen');
              }, icon: Icon(Icons.account_circle_rounded),iconSize: 35,)
          ),

        ],
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
