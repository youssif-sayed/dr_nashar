import 'package:dr_nashar/components.dart';
import 'package:dr_nashar/main.dart';
import 'package:dr_nashar/screens/student_marks_screen.dart';
import 'package:dr_nashar/user/UserID.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/ShowToast.dart';
import '../user/yearsData.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  String password = '';

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var localization = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 80,
                  width: width * .25 - 12,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: UserID.userdata['gender'] == 'male'
                            ? [
                                const Color(0xff08CE5D),
                                const Color(0xff098FEA),
                              ]
                            : [
                                const Color(0xfff953c6),
                                const Color(0xffb91d73),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(15.0)),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 75,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 15.0),
                SizedBox(
                  width: width * .75 - 27,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10.0),
                      Text(
                        UserID.userdata['firstName'] +
                            ' ' +
                            UserID.userdata['lastName'],
                        maxLines: 3,
                        softWrap: true,
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
                  ),
                )
              ],
            ),

            const SizedBox(
              height: 30.0,
            ),

            Text(
              localization.dashboard,
              style: const TextStyle(
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
              localization.marks,
              const Color(0xff098FEA),
              () {
                showLoadingDialog(context);
                YearsData.getStudentMarks().then((value) {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const StudentMarksScreen()));
                });
              },
              true,
            ),

            const SizedBox(height: 15.0),

            userInfo(Icons.language, localization.language, Colors.green, () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const LanguagesScreen()));
            }, true),

            const SizedBox(height: 15.0),

            userInfo(Icons.delete_rounded, 'Delete Account', Colors.red,
                () async {
              showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(builder: (context, setState) {
                    return AlertDialog(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                      title: const Text(
                        'Enter password to confirm',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      content: TextField(
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                      actions: [
                        TextButton(
                          child: const Text(
                            'cancel',
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        isLoading
                            ? const SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(
                                  color: Colors.red,
                                ),
                              )
                            : TextButton(
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 20),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  if (password != '') {
                                    try {
                                      final logedUserEmail = FirebaseAuth
                                          .instance.currentUser?.email;
                                      final credential = await FirebaseAuth
                                          .instance
                                          .signInWithEmailAndPassword(
                                              email: logedUserEmail!,
                                              password: password);
                                      final user = credential.user;
                                      //await FirebaseFirestore.instance.collection('userData').doc('${user?.uid}').delete();
                                      await user?.delete();
                                      await FirebaseAuth.instance.signOut();
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil('Intro',
                                              (Route<dynamic> route) => false);
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'wrong-password') {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        ShowToast(
                                            'wrong password', ToastGravity.TOP);
                                      }
                                    }
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    ShowToast(
                                        'enter password', ToastGravity.TOP);
                                  }
                                }),
                      ],
                    );
                  });
                },
              );
            }, false),

            const SizedBox(height: 15.0),

            userInfo(Icons.logout_rounded, localization.logout, Colors.red,
                () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  'Intro', (Route<dynamic> route) => false);
            }, false),

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

class LanguagesScreen extends StatelessWidget {
  const LanguagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ValueListenableBuilder(
            valueListenable: language,
            builder: (context, lang, _) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    ListTile(
                      trailing: language.value == 'en'
                          ? const Icon(
                              Icons.check_rounded,
                              color: Colors.green,
                            )
                          : null,
                      onTap: () {
                        language.value = 'en';
                      },
                      title: const Text(
                        'English',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      trailing: language.value == 'ar'
                          ? const Icon(
                              Icons.check_rounded,
                              color: Colors.green,
                            )
                          : null,
                      onTap: () {
                        language.value = 'ar';
                      },
                      title: const Text(
                        'اللغة العربية',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
