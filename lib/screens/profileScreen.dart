import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/ShowToast.dart';


class ProfileScreen extends StatefulWidget {
   ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  String password='';

  bool isLoading=false;

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
              onTap: (){
                showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context,setState) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12.0))),
                          title: const Text(
                            'Enter password to confirm',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                          content: TextField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                            ),
                            onChanged: (value){password=value;},),
                          actions: [
                            TextButton(
                              child: const Text(
                                'cancel',
                                style: TextStyle(color: Colors.grey,fontSize: 20),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            isLoading?Container(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(color: Colors.red,),
                            ):TextButton(
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red,fontSize: 20),
                              ),
                              onPressed: () async {
                                setState(() {
                                  isLoading=true;
                                });
                                if (password!=''){
                                  try {
                                    final logedUserEmail= FirebaseAuth.instance.currentUser?.email;
                                    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                        email: logedUserEmail!,
                                        password: password
                                    );
                                    final user = credential.user;
                                    await FirebaseFirestore.instance.collection('userData').doc('${user?.uid}').delete();
                                    await user?.delete();
                                    setState(() {
                                      isLoading=false;
                                    });
                                    Navigator.of(context).pushNamedAndRemoveUntil('Intro',(Route<dynamic> route) => false);
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'wrong-password') {
                                      setState(() {
                                        isLoading=false;
                                      });
                                      ShowToast('wrong password', ToastGravity.TOP);
                                    }
                                  }


                                }
                                else{
                                  setState(() {
                                    isLoading=false;
                                  });
                                  ShowToast('enter password', ToastGravity.TOP);
                                }
                              }
                            ),
                          ],
                        );
                      }
                    );
                  },
                );
              },

              title: Text('Delete Account',style: TextStyle(fontSize: 20),),

              leading: Icon(Icons.delete_rounded),
            ),
            ListTile(
              iconColor: Colors.red,
              textColor: Colors.red,
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil('Intro',(Route<dynamic> route) => false);
              },
              title: Text('Log out',style: TextStyle(fontSize: 20),),

              leading: Icon(Icons.logout_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
