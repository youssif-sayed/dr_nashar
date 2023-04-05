import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_rec/conditional_builder_rec.dart';
import 'package:dr_nashar/main.dart';
import 'package:dr_nashar/user/yearsData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../user/UserID.dart';

class StudentMarksScreen extends StatelessWidget {
  const StudentMarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    YearsData.getStudentMarks();

    return ConditionalBuilderRec(
      condition: YearsData.studentAssignments != null &&
          YearsData.studentQuizzes != null,
      fallback: (context) => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.green,
          ),
        ),
      ),
      builder: (context) {
        return Scaffold(
          backgroundColor: CupertinoColors.white,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.black,
            title: SizedBox(
              height: 50,
              child: Hero(
                tag: 'logo',
                child: Image.asset(
                  'images/Icon/appIcon.png',
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localization.assignments,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10.0),
                    itemBuilder: (context, index) {
                      bool stepsMarksExists() {
                        return !YearsData.studentAssignments[index]
                                .data()
                                .containsKey('steps_marks')
                            ? false
                            : true;
                      }

                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    YearsData.studentAssignments[index]
                                        ['assignment_name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                    Text(
                                      YearsData.studentAssignments[index]
                                              ['right_answers']
                                          .toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ),
                                    Text(
                                      YearsData.studentAssignments[index]
                                              ['wrong_answers']
                                          .toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Mark',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Text(
                                      YearsData.studentAssignments[index]
                                          ['assignment_marks'],
                                      textDirection: TextDirection.ltr,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            stepsMarksExists()
                                ? Row(
                                    children: [
                                      const Text(
                                        'Steps Marks',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        YearsData.studentAssignments[index]
                                            ['steps_marks'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox()
                          ],
                        ),
                      );
                    },
                    itemCount: YearsData.studentAssignments.length,
                  ),
                  const SizedBox(height: 20.0),
                  const Divider(),
                  const SizedBox(height: 20.0),
                  Text(
                    localization.quizzes,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10.0),
                    itemBuilder: (context, index) {
                      bool stepsMarksExists() {
                        return !YearsData.studentQuizzes[index]
                                .data()
                                .containsKey('steps_marks')
                            ? false
                            : true;
                      }

                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    YearsData.studentQuizzes[index]
                                        ['quiz_name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                    Text(
                                      YearsData.studentQuizzes[index]
                                              ['right_answers']
                                          .toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ),
                                    Text(
                                      YearsData.studentQuizzes[index]
                                              ['wrong_answers']
                                          .toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      localization.marks,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    Text(
                                      YearsData.studentQuizzes[index]
                                          ['quiz_marks'],
                                      textDirection: TextDirection.ltr,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            stepsMarksExists()
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Steps Marks',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        YearsData.studentQuizzes[index]
                                            ['steps_marks'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox()
                          ],
                        ),
                      );
                    },
                    itemCount: YearsData.studentQuizzes.length,
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    localization.attendance,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('attendence')
                        .where('student_uid', isEqualTo: UserID.userID!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(
                            color: Colors.grey,
                          ),
                        ));
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(localization.no_attendance_found),
                          ),
                        );
                      }
                      final attendances = snapshot.data!.docs;
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: attendances.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return StudentAttendance(
                            attendance: attendances[index].data(),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class StudentAttendance extends StatelessWidget {
  final Map attendance;

  const StudentAttendance({super.key, required this.attendance});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.circle,
          color: Colors.green,
          size: 20,
        ),
        const SizedBox(width: 10.0),
        Text(
          _getDayName(attendance['time']),
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(
              _formatAttendanceDate(attendance['time']),
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getDayName(Timestamp timestamp) {
    final date = timestamp.toDate();
    return DateFormat.EEEE(language.value).format(date);
  }

  String _formatAttendanceDate(Timestamp timestamp) {
    final date = timestamp.toDate();

    return DateFormat.yMd(language.value).add_jm().format(date);
  }
}
