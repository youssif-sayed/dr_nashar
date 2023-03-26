// Flutter imports:
import 'dart:io' show Platform;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:rive/rive.dart';

import '../user/UserID.dart';
import '../utils/colors_palette.dart';
import '../utils/gaps.dart';
import '../widgets/ShowToast.dart';
import '../widgets/text_input.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false;
  double progress = 0;
  bool _ismale = true;
  bool _isonsite = true;
  String _email = '';
  String _password = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _errorText;
  FilePickerResult? result;
  String _fullName = '';
  String _firstName = '';
  String _lastName = '';
  String _gender = 'male';
  String _phone = '';
  String _fatherPhone = '';
  String _motherPhone = '';
  String _parentJop = '';
  String _gov = 'Cairo';
  String _school = '';
  String _grade = 'first secondary';
  String _place = 'center';
  final List<String> _gradeList = [
    'first preparatory',
    'second preparatory',
    'third preparatory',
    'first secondary',
    'second secondary',
    'third secondary'
  ];
  final List<String> _govList = [
    'Alexandria',
    'Aswan',
    'Asyut',
    'Beheira',
    'Beni Suef',
    'Cairo',
    'Dakahlia',
    'Damietta',
    'Faiyum',
    'Gharbia',
    'Giza',
    'Ismailia',
    'Kafr El Sheikh	',
    'Luxor',
    'Matruh',
    'Minya',
    'Monufia',
    'New Valley',
    'North Sinai',
    'Port Said',
    'Qalyubia',
    'Qena',
    'Red Sea',
    'Sharqia',
    'Sohag',
    'South Sinai',
    'Suez'
  ];

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 200,
                        child: RiveAnimation.asset(
                          'images/animatedLogo.riv',
                        ),
                      ),
                      Column(
                        children: [
                          Text(localization.welcome,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 25.0)),
                          const Text('Dr.Nashar',
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 25.0)),
                        ],
                      ),
                    ],
                  ),
                  Gaps.gap48,
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localization.personal_information,
                                style: const TextStyle(
                                    color: Colors.lightBlueAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              Gaps.gap16,
                              TextInput(
                                hint: 'email',
                                prefixIcon: Icons.email,
                                inputType: TextInputType.emailAddress,
                                validator: (String? email) {
                                  if (email == null || email.isEmpty) {
                                    return localization
                                        .email_address_is_required;
                                  }
                                  if (!RegExp(
                                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                      .hasMatch(email)) {
                                    return localization
                                        .email_address_is_required;
                                  }
                                  return null;
                                },
                                onChanged: (String? email) {
                                  _email = email!.trim();
                                },
                              ), //email
                              Gaps.gap12,
                              TextInput(
                                hint: localization.password,
                                prefixIcon: Icons.lock,
                                inputType: TextInputType.visiblePassword,
                                validator: (String? password) {
                                  if (password == null || password.isEmpty) {
                                    return localization.password_is_required;
                                  }
                                  return null;
                                },
                                onChanged: (String? password) {
                                  _password = password!.trim();
                                },
                              ), //password
                              Gaps.gap12,
                              Row(
                                children: [
                                  Expanded(
                                    child: TextInput(
                                      hint: localization.first_name,
                                      validator: (String? name) {
                                        if (name == null || name.isEmpty) {
                                          return localization
                                              .first_name_is_required;
                                        }
                                        return null;
                                      },
                                      inputType: TextInputType.name,
                                      onChanged: (name) {
                                        _firstName = name!;
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: TextInput(
                                      hint: localization.last_name,
                                      validator: (String? name) {
                                        if (name == null || name.isEmpty) {
                                          return localization
                                              .last_name_is_required;
                                        }
                                        return null;
                                      },
                                      inputType: TextInputType.name,
                                      onChanged: (name) {
                                        _lastName = name!;
                                      },
                                    ),
                                  ),
                                ],
                              ), // first ans last name
                              Gaps.gap12,
                              TextInput(
                                hint: localization.full_name_in_arabic,
                                validator: (String? name) {
                                  if (name == null || name.isEmpty) {
                                    return localization.full_name_is_required;
                                  }
                                  return null;
                                },
                                inputType: TextInputType.name,
                                onChanged: (name) {
                                  _fullName = name!;
                                },
                              ), //full name
                              Gaps.gap12,
                              TextInput(
                                hint: localization.mobile_number,
                                validator: (String? name) {
                                  if (name == null || name.isEmpty) {
                                    return localization
                                        .mobile_number_is_required;
                                  }
                                  return null;
                                },
                                inputType: TextInputType.number,
                                onChanged: (name) {
                                  _phone = name!;
                                },
                              ), //mobile number
                              Gaps.gap12,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              _ismale = true;
                                              _gender = 'male';
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: _ismale
                                                    ? Colors.amberAccent
                                                    : Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(250)),
                                            child: Image.asset(
                                              'images/male.png',
                                            ),
                                          ),
                                        ),
                                        Gaps.gap4,
                                        Text(
                                          localization.male,
                                          style: TextStyle(
                                              color: _ismale
                                                  ? Colors.amberAccent
                                                  : Colors.grey,
                                              fontSize: 25),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              _ismale = false;
                                              _gender = 'female';
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: _ismale
                                                    ? Colors.grey
                                                    : Colors.amberAccent,
                                                borderRadius:
                                                    BorderRadius.circular(250)),
                                            child: Image.asset(
                                              'images/female.png',
                                            ),
                                          ),
                                        ),
                                        Gaps.gap4,
                                        Text(
                                          localization.female,
                                          style: TextStyle(
                                              color: _ismale
                                                  ? Colors.grey
                                                  : Colors.amberAccent,
                                              fontSize: 25),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ), //gender
                              Gaps.gap12,
                              Text(
                                '${localization.student_picture} :',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Gaps.gap8,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.blueAccent,
                                    ),
                                    child: result == null
                                        ? IconButton(
                                            color: Colors.white,
                                            iconSize: 40,
                                            onPressed: () async {
                                              final pickedfile =
                                                  await FilePicker.platform
                                                      .pickFiles(
                                                          type: FileType.image,
                                                          withData: true);
                                              setState(() {
                                                result = pickedfile;
                                              });
                                            },
                                            icon:
                                                const Icon(Icons.image_rounded),
                                          )
                                        : Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                75,
                                            constraints: const BoxConstraints(
                                                maxWidth: 300),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      result = null;
                                                    });
                                                  },
                                                  icon: const Icon(
                                                      Icons.cancel_rounded),
                                                  color: Colors.blueAccent,
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  '${result?.files.first.name}',
                                                  style: const TextStyle(
                                                      color: Colors.blueAccent),
                                                  maxLines: 10,
                                                )),
                                              ],
                                            ),
                                          ),
                                  ),
                                ],
                              ), //picture
                              Gaps.gap24,
                              Text(
                                localization.parents_information,
                                style: const TextStyle(
                                    color: Colors.lightBlueAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              Gaps.gap16,
                              TextInput(
                                hint: localization.parents_job,
                                validator: (String? name) {
                                  if (name == null || name.isEmpty) {
                                    return localization.parents_job_is_required;
                                  }
                                  return null;
                                },
                                inputType: TextInputType.name,
                                onChanged: (name) {
                                  _parentJop = name!;
                                },
                              ), //job
                              Gaps.gap16,
                              Row(
                                children: [
                                  Expanded(
                                    child: TextInput(
                                      hint: localization.fathers_number,
                                      validator: (String? name) {
                                        if (name == null || name.isEmpty) {
                                          // #TODO
                                          return 'number is required';
                                        }
                                        return null;
                                      },
                                      inputType: TextInputType.number,
                                      onChanged: (name) {
                                        _fatherPhone = name!;
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: TextInput(
                                      hint: localization.mothers_number,
                                      validator: (String? name) {
                                        if (name == null || name.isEmpty) {
                                          // #TODO
                                          return 'number is required';
                                        }
                                        return null;
                                      },
                                      inputType: TextInputType.number,
                                      onChanged: (name) {
                                        _motherPhone = name!;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Gaps.gap24,
                              Text(
                                localization.education_information,
                                style: const TextStyle(
                                    color: Colors.lightBlueAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              Gaps.gap12,
                              TextInput(
                                hint: localization.school_name,
                                validator: (String? name) {
                                  if (name == null || name.isEmpty) {
                                    // #TODO
                                    return 'School name is required';
                                  }
                                  return null;
                                },
                                inputType: TextInputType.name,
                                onChanged: (name) {
                                  _school = name!;
                                },
                              ), //school
                              Gaps.gap12,
                              Text(
                                '${localization.government} :',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Gaps.gap8,
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(90)),
                                child: DropdownButton(
                                  isExpanded: true,
                                  underline: Container(),
                                  focusColor: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(15),
                                  value: _gov,
                                  icon: const Icon(Icons.unfold_more_rounded),
                                  items: _govList.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(
                                        items,
                                        style: const TextStyle(
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _gov = newValue!;
                                    });
                                  },
                                ),
                              ),
                              Gaps.gap12,
                              Text(
                                '${localization.grade} :',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Gaps.gap8,
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(90)),
                                child: DropdownButton(
                                  isExpanded: true,
                                  underline: Container(),
                                  focusColor: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(15),
                                  value: _grade,
                                  icon: const Icon(Icons.unfold_more_rounded),
                                  items: _gradeList.map((String item) {
                                    return DropdownMenuItem(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _grade = newValue!;
                                    });
                                  },
                                ),
                              ),

                              Gaps.gap16,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              _isonsite = true;
                                              _place = 'center';
                                            });
                                          },
                                          child: Container(
                                            constraints: const BoxConstraints(
                                                maxWidth: 150),
                                            decoration: BoxDecoration(
                                                color: _isonsite
                                                    ? Colors.green
                                                    : Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(250)),
                                            child: Image.asset(
                                              'images/on-site.png',
                                            ),
                                          ),
                                        ),
                                        Gaps.gap4,
                                        Text(
                                          localization.center,
                                          style: TextStyle(
                                              color: _isonsite
                                                  ? Colors.green
                                                  : Colors.grey,
                                              fontSize: 25),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              _isonsite = false;
                                              _place = 'online';
                                            });
                                          },
                                          child: Container(
                                            constraints: const BoxConstraints(
                                                maxWidth: 150),
                                            decoration: BoxDecoration(
                                                color: _isonsite
                                                    ? Colors.grey
                                                    : Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(250)),
                                            child: Image.asset(
                                              'images/online.png',
                                            ),
                                          ),
                                        ),
                                        Gaps.gap4,
                                        Text(
                                          localization.online,
                                          style: TextStyle(
                                              color: _isonsite
                                                  ? Colors.grey
                                                  : Colors.green,
                                              fontSize: 25),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ), //place
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shadowColor: Colors.blueAccent,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                                minimumSize: const Size(400, 50),
                              ),
                              onPressed: () async {
                                await _signUp(context);
                              },
                              child: Text(
                                localization.sign_up,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                            if (_errorText != null) ...[
                              Gaps.gap16,
                              Text(
                                _errorText!,
                                style: const TextStyle(
                                  color: ColorsPalette.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                            Gaps.gap8,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  localization.have_an_account,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushReplacementNamed('SignInScreen');
                                  },
                                  child: Text(
                                    localization.sign_in,
                                    style: const TextStyle(
                                        color: Colors.pinkAccent),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(),
                ],
              ),
            ),
          ),
          isLoading
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: const Color(0x80000000),
                  child: Center(
                      child: SizedBox(
                    height: 100.0,
                    width: progress == 100.0 ? double.infinity : 100,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 375),
                      child: progress == 100.0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check_rounded,
                                  color: Colors.green,
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Text(localization.user_created,
                                    style:
                                        const TextStyle(color: Colors.green)),
                              ],
                            )
                          : const CircularProgressIndicator(),

                      // LiquidCircularProgressIndicator(
                      //   value: progress / 100,
                      //   valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                      //   backgroundColor: Colors.white,
                      //   direction: Axis.vertical,
                      //   center: Text(
                      //     "$progress%",
                      //     style: TextStyle(fontSize: 25),
                      //   ),
                      // ),
                    ),
                  )),
                )
              : Container(),
        ]),
      ),
    );
  }

  Future<void> _signUp(BuildContext context) async {
    final formState = _formKey.currentState;
    setState(() => _errorText = null);

    if (formState != null) {
      if (formState.validate()) {
        formState.save();

        final deviceInfoPlugin = DeviceInfoPlugin();
        final deviceInfo = await deviceInfoPlugin.deviceInfo;
        if (Platform.isAndroid) UserID.userdata['UIDV'] = deviceInfo.data['id'];
        if (Platform.isIOS) {
          UserID.userdata['UIDV'] = deviceInfo.data['identifierForVendor'];
        }

        Uint8List? file = result?.files.first.bytes;
        String fileName = "users/${_email}.${result?.files.first.extension}";

        UserID.userdata['photo'] = fileName;
        UserID.userdata['firstName'] = _firstName;
        UserID.userdata['lastName'] = _lastName;
        UserID.userdata['fullName'] = _fullName;
        UserID.userdata['gender'] = _gender;
        UserID.userdata['phone'] = _phone;
        UserID.userdata['email'] = _email;
        UserID.userdata['gov'] = _gov;
        UserID.userdata['parentJob'] = _parentJop;
        UserID.userdata['fatherPhone'] = _fatherPhone;
        UserID.userdata['motherPhone'] = _motherPhone;
        UserID.userdata['school'] = _school;
        UserID.userdata['grade'] = _grade;
        UserID.userdata['place'] = _place;

        User? user = await signUpUsingEmailPassword(
          email: _email,
          password: _password,
          context: context,
        );

        if (user?.uid != null) {
          print('email created');
          setState(() {
            isLoading = true;
          });
          await user?.sendEmailVerification();
          await user?.updateDisplayName(_firstName);

          UserID.userID = user;
          UploadTask task = FirebaseStorage.instance
              .ref()
              .child(fileName)
              .putData(
                  file!,
                  SettableMetadata(
                      contentType: "image/${result?.files.first.extension}"));
          task.snapshotEvents.listen((event) {
            setState(() {
              print('uploading image');
              progress = ((event.bytesTransferred.toDouble() /
                          event.totalBytes.toDouble()) *
                      100)
                  .roundToDouble();

              if (progress == 100) {
                event.ref.getDownloadURL().then((downloadUrl) {
                  print(downloadUrl);
                  user?.updatePhotoURL(downloadUrl);
                });
                uploadData();
              }

              print(progress);
            });
          });
        } else {
          setState(() => _errorText = 'erorr in sign up');
        }
      }
    }
  }

  static Future<User?> signUpUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ShowToast('The password provided is too weak.', ToastGravity.TOP);
      } else if (e.code == 'email-already-in-use') {
        ShowToast(
            'The account already exists for that email.', ToastGravity.TOP);
      }
    } catch (e) {
      print(e);
    }
    if (user != null) {
      await FirebaseFirestore.instance
          .collection("userData")
          .doc('${user?.uid}')
          .set(UserID.userdata)
          .onError((e, _) => print("Error writing document: $e"));
    }
    return user;
  }

  Future<void> uploadData() async {
    print('data pushed');
    FirebaseAuth.instance.signOut();
    setState(() {
      isLoading = false;
    });
    ShowToast('Email created successfully!', ToastGravity.TOP);

    Navigator.pushReplacementNamed(context, 'SignInScreen');
  }
}
