import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_nashar/user/UserID.dart';

import '../models/video_model.dart';

class YearsData {
  static var defultYear;
  static var sec1, sec2, sec3, prep1, prep2, prep3;
  static var selectedSubject, selectedYear, subjectQuiz, subjectAssignment;

  static List<LectureModel> subjectData = [];

  static var studentQuizzes, studentAssignments;
  static var lectureNumber, lectureCodes, lectureID;

  static void set_defult_year() {
    switch (UserID.userdata['grade']) {
      case 'first preparatory':
        {
          defultYear = 'prep1';
          break;
        }
      case 'second preparatory':
        {
          defultYear = 'prep2';
          break;
        }
      case 'third preparatory':
        {
          defultYear = 'prep3';
          break;
        }
      case 'first secondary':
        {
          defultYear = 'sec1';
          break;
        }
      case 'second secondary':
        {
          defultYear = 'sec2';
          break;
        }
      case 'third secondary':
        {
          defultYear = 'sec3';
          break;
        }
    }
  }

  static Future<bool> get_years_data() async {
    await FirebaseFirestore.instance
        .collection("sec1-lectures")
        .get()
        .then((value) {
      sec1 = value.docs;
    });
    await FirebaseFirestore.instance
        .collection("sec2-lectures")
        .get()
        .then((value) {
      sec2 = value.docs;
    });
    await FirebaseFirestore.instance
        .collection("sec3-lectures")
        .get()
        .then((value) {
      sec3 = value.docs;
    });
    await FirebaseFirestore.instance
        .collection("prep1-lectures")
        .get()
        .then((value) {
      prep1 = value.docs;
    });
    await FirebaseFirestore.instance
        .collection("prep2-lectures")
        .get()
        .then((value) {
      prep2 = value.docs;
    });
    await FirebaseFirestore.instance
        .collection("prep3-lectures")
        .get()
        .then((value) {
      prep3 = value.docs;
    });

    return true;
  }

  static Future<bool> get_subject_data() async {
    await FirebaseFirestore.instance
        .collection("$selectedYear-lectures")
        .doc('$selectedSubject')
        .collection('lectures')
        .get()
        .then((value) {
      subjectData =
          value.docs.map((e) => LectureModel.fromJson(e.data())).toList();
    });
    // await FirebaseFirestore.instance
    //     .collection("$selectedYear-lectures")
    //     .doc('$selectedSubject')
    //     .collection('quiz')
    //     .get()
    //     .then((value) {
    //   subjectQuiz = value.docs;
    // });
    // await FirebaseFirestore.instance
    //     .collection("$selectedYear-lectures")
    //     .doc('$selectedSubject')
    //     .collection('assignment')
    //     .get()
    //     .then((value) {
    //   subjectAssignment = value.docs;
    // });
    return true;
  }

  // check existence :- used to force the student to take the quiz only ONCE.
  // static bool checkQuizExistence() {
  //   bool exist = false;
  //   FirebaseFirestore.instance
  //       .collection("$selectedYear-lectures")
  //       .doc('$selectedSubject')
  //       .collection('quiz')
  //       .doc('students/${UserID.userID!.uid}')
  //       .get()
  //       .then((onexist) {
  //     onexist.exists ? exist = true : exist = false;
  //   });
  //   if (exist = true) {
  //     print('exist');
  //   } else {
  //     print('Error');
  //   }

  //   return exist;
  // }

  // Send quiz
  static sendQuiz({required quiz}) async {
    // await FirebaseFirestore.instance
    //     .collection("$selectedYear-lectures")
    //     .doc('$selectedSubject')
    //     .collection('quiz')
    //     .doc('students')
    //     .set(quiz)
    //     .then((value) {
    //   print('added successfully!');
    // }).catchError((error) {
    //   {
    //     print(error.toString());
    //   }
    // });

    await FirebaseFirestore.instance
        .collection("userData")
        .doc(UserID.userID!.uid)
        .collection('quizzes')
        .add(quiz[UserID.userID!.uid])
        //.add(quiz[UserID.userID!.uid])
        .then((value) {
      print('added successfully!');
    }).catchError((error) {
      {
        print(error.toString());
      }
    });

    getStudentMarks();
  }

  // check existence :- used to force the student to take the quiz only ONCE.
  // static bool checkAssignmentExistence() {
  //   bool exist = false;
  //   FirebaseFirestore.instance
  //       .collection("$selectedYear-lectures")
  //       .doc('$selectedSubject')
  //       .collection('assignment')
  //       .doc('students/${UserID.userID!.uid}')
  //       .get()
  //       .then((onexist) {
  //     onexist.exists ? exist = true : exist = false;
  //   });
  //   if (exist = true) {
  //     print('exist');
  //   } else {
  //     print('Error');
  //   }

  //   return exist;
  // }

  // Send Assignment
  static sendAssignment({required assignment}) async {
    // await FirebaseFirestore.instance
    //     .collection("$selectedYear-lectures")
    //     .doc('$selectedSubject')
    //     .collection('assignment')
    //     .doc('students')
    //     .set(assignment)
    //     .then((value) {
    //   print('added successfully!');
    // }).catchError((error) {
    //   {
    //     print(error.toString());
    //   }
    // });

    await FirebaseFirestore.instance
        .collection("userData")
        .doc(UserID.userID!.uid)
        .collection('assignments')
        .add(
          assignment[UserID.userID!.uid],
        )
        .then((value) {
      print('added successfully!');
    }).catchError((error) {
      {
        print(error.toString());
      }
    });

    getStudentMarks();
  }

  static Future<bool> get_lecture_codes(index) async {
    await FirebaseFirestore.instance
        .collection("codes")
        .doc('general')
        .get()
        .then((value) {
      lectureCodes = value.data() as Map<String, dynamic>;
    });
    return true;
  }

  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  static void update_code_data(date, uid, code, index, map) async {
    var updatedmap = map;
    Timestamp timeStamp = Timestamp.fromDate(date);
    updatedmap['used'] = true;
    updatedmap['UID'] = uid;
    updatedmap['startDate'] = timeStamp;
    await FirebaseFirestore.instance
        .collection('codes')
        .doc('general')
        .update({'$code': updatedmap});
  }

  // student marks
  static Future getStudentMarks() async {
    await FirebaseFirestore.instance
        .collection("userData")
        .doc(UserID.userID!.uid)
        .collection('quizzes')
        .get()
        .then((value) {
      studentQuizzes = value.docs;
      studentQuizzes.forEach((element) {
        print(element.id);
      });
    }).catchError((error) {
      {
        print(error.toString());
      }
    });

    await FirebaseFirestore.instance
        .collection("userData")
        .doc(UserID.userID!.uid)
        .collection('assignments')
        .get()
        .then((value) {
      studentAssignments = value.docs;
      studentAssignments.forEach((element) {
        print(element.id);
      });
    }).catchError((error) {
      {
        print(error.toString());
      }
    });
  }
}
