import 'package:dr_nashar/modules/payment/cubit/cubit.dart';
import 'package:dr_nashar/user/yearsData.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';

import '../user/UserID.dart';
import '../utils/gaps.dart';
import '../widgets/ShowToast.dart';

class SubjectScreen extends StatefulWidget {
  const SubjectScreen({Key? key}) : super(key: key);

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  String errtxt = '';
  String code = '';
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
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(12),
        child: YearsData.subjectData.length == 0
            ? SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'The course is currently empty',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Image.asset(
                      'images/empty_list.png',
                      color: Colors.white.withOpacity(0.5),
                      colorBlendMode: BlendMode.modulate,
                    ),
                  ],
                ),
            )
            : ListView.builder(
                itemCount: YearsData.subjectData.length,
                itemBuilder: (context, index) {
                  return listItem(index);
                }),
      ),
    );
  }

  Widget listItem(int index) {
    return Column(
      children: [

        Gaps.gap24,
        ListTile(
          title: Container(
            padding: EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${YearsData.subjectData[index]['name']}',
                  style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey),
                  maxLines: 3,
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(18.0))),
                          title: Text(
                            'Confirmation',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                          content: const Text(
                            'Are you sure you want to buy this lesson',
                            style: TextStyle(color: Colors.black),
                          ),
                          actions: [
                            TextButton(
                              child: const Text(
                                'NO',
                                style: TextStyle(
                                    color: Colors.red, fontSize: 20),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: const Text(
                                'YES',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 20),
                              ),
                              onPressed: () async {
                                YearsData.lectureNumber = index;
                                YearsData.lectureID =
                                YearsData.subjectData[index]['id'];
                                Navigator.of(context)
                                    .pushReplacementNamed('LoadingPayScreen');
                              },
                            )
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      'Buy ${YearsData.subjectData[index]['price']}EGP',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: Container(
                            height: 200,
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Gaps.gap32,
                                      TextField(
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'code',
                                          hintText: 'Enter Your code',
                                        ),
                                        onChanged: (value) {
                                          code = value;
                                        },
                                      ),
                                      Text(
                                        errtxt,
                                        style: const TextStyle(
                                            color: Colors.red, fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    MaterialButton(
                                      onPressed: () async {
                                        bool iscode = false;
                                        int i = 0;
                                        DateTime nowDate = DateTime.now();
                                        final codesData =
                                        await YearsData.get_lecture_codes(
                                            index);
                                        if (codesData) print('');

                                        for (;
                                        i < YearsData.lectureCodes.length;
                                        i++) {
                                          if (YearsData.lectureCodes.keys
                                              .elementAt(i) ==
                                              code) {
                                            iscode = true;
                                            break;
                                          }
                                        }
                                        if (iscode &&YearsData.lectureCodes.values.elementAt(i)['price']==YearsData.subjectData[index]['price']) {
                                          if (YearsData.lectureCodes.values
                                              .elementAt(i)['used']) {
                                            if (YearsData.lectureCodes.values
                                                .elementAt(i)['UID'] ==
                                                UserID.userID?.uid) {
                                              DateTime codeDate = YearsData
                                                  .lectureCodes.values
                                                  .elementAt(i)['startDate']
                                                  .toDate();
                                              final dateDifrance =
                                              YearsData.daysBetween(
                                                  codeDate, nowDate);
                                              if (dateDifrance <=
                                                  YearsData
                                                      .lectureCodes.values
                                                      .elementAt(
                                                      i)['expireDate']) {
                                                YearsData.lectureNumber =
                                                    index;
                                                Navigator.of(context)
                                                    .pushReplacementNamed(
                                                    'VideoScreen');
                                              } else {
                                                ShowToast('code expired',
                                                    ToastGravity.TOP);
                                              }
                                            } else {
                                              ShowToast('not allowed user',
                                                  ToastGravity.TOP);
                                            }
                                          } else {
                                            YearsData.update_code_data(
                                                nowDate,
                                                UserID.userID?.uid,
                                                code,
                                                index,
                                                YearsData.lectureCodes.values
                                                    .elementAt(i));
                                            YearsData.lectureNumber = index;
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                'VideoScreen');
                                          }
                                        } else {
                                          ShowToast('code not valid',
                                              ToastGravity.TOP);
                                        }
                                      },
                                      child: Container(
                                        width:
                                        MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            color: Colors.blueAccent,
                                            borderRadius:
                                            BorderRadius.circular(50)),
                                        height: 50,
                                        child: const Center(
                                          child: Text(
                                            'Enter',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Gaps.gap32,
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                  //YearsData.lectureNumber=index;
                  //Navigator.of(context).pushNamed('VideoScreen');
                },
                leading: Container(
                  decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(50)),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                title: Text(
                  '${YearsData.subjectData[index]['videos'].length} videos, ${YearsData.subjectData[index]['docs'].length} documents',
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.teal,
                      fontWeight: FontWeight.w700),
                  maxLines: 3,
                ),
              ),
              const Divider(
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),
              // Assignment
              ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed('AssignmentScreen');
                },
                leading: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(50)),
                  child: const Icon(
                    Icons.description_rounded,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                title: const Text(
                  'Assignment',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.teal,
                      fontWeight: FontWeight.w700),
                  maxLines: 3,
                ),
              ),
              const Divider(
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),
              // Quiz
              ListTile(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: SizedBox(
                            height: 200,
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Gaps.gap32,
                                      TextField(
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'code',
                                          hintText: 'Enter Your code',
                                        ),
                                        onChanged: (value) {
                                          code = value;
                                        },
                                      ),
                                      Text(
                                        errtxt,
                                        style: const TextStyle(
                                            color: Colors.red, fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    MaterialButton(
                                      onPressed: () async {
                                        bool iscode = false;
                                        int i = 0;
                                        DateTime nowDate = DateTime.now();
                                        final codesData =
                                        await YearsData.get_lecture_codes(
                                            index);
                                        if (codesData) print('');

                                        for (;
                                        i < YearsData.lectureCodes.length;
                                        i++) {
                                          if (YearsData.lectureCodes.keys
                                              .elementAt(i) ==
                                              code) {
                                            iscode = true;
                                            break;
                                          }
                                        }
                                        if (iscode) {
                                          if (YearsData.lectureCodes.values
                                              .elementAt(i)['used']) {
                                            if (YearsData.lectureCodes.values
                                                .elementAt(i)['UID'] ==
                                                UserID.userID?.uid) {
                                              DateTime codeDate = YearsData
                                                  .lectureCodes.values
                                                  .elementAt(i)['startDate']
                                                  .toDate();
                                              final dateDifrance =
                                              YearsData.daysBetween(
                                                  codeDate, nowDate);
                                              if (dateDifrance <=
                                                  YearsData
                                                      .lectureCodes.values
                                                      .elementAt(
                                                      i)['expireDate']) {
                                                YearsData.lectureNumber =
                                                    index;
                                                Navigator.of(context)
                                                    .pushReplacementNamed(
                                                    'QuizScreen');
                                              } else {
                                                ShowToast('code expired',
                                                    ToastGravity.TOP);
                                              }
                                            } else {
                                              ShowToast('not allowed user',
                                                  ToastGravity.TOP);
                                            }
                                          } else {
                                            YearsData.update_code_data(
                                                nowDate,
                                                UserID.userID?.uid,
                                                code,
                                                index,
                                                YearsData.lectureCodes.values
                                                    .elementAt(i));
                                            YearsData.lectureNumber = index;
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                'QuizScreen');
                                          }
                                        } else {
                                          ShowToast('code not valid',
                                              ToastGravity.TOP);
                                        }
                                      },
                                      child: Container(
                                        width:
                                        MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            color: Colors.blueAccent,
                                            borderRadius:
                                            BorderRadius.circular(50)),
                                        height: 50,
                                        child: const Center(
                                          child: Text(
                                            'Enter',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Gaps.gap32,
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
                leading: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(50)),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                title: const Text(
                  'Quiz',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.teal,
                      fontWeight: FontWeight.w700),
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
