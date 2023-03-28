import 'package:dr_nashar/components.dart';
import 'package:dr_nashar/models/video_model.dart';
import 'package:dr_nashar/widgets/ShowToast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../models/question_model.dart';
import '../user/UserID.dart';
import '../user/yearsData.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({Key? key, required this.lecture}) : super(key: key);
  final LectureModel lecture;

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  int currentStep = 1;
  int? selectedAnswer;
  Map<dynamic, dynamic> answers = {}; // question id : answer id
  Map<dynamic, dynamic> answersIndexes = {};
  List<QuestionModel> assignmentQuestions = [];
  int rightAnswers = 0;
  int wrongAnswers = 0;
  late Map<String, dynamic> finalAnswers = {
    UserID.userID!.uid: {
      'assignment_name': '${YearsData.selectedSubject} assignment',
      'assignment': [],
      'right_answers': 0,
      'wrong_answers': 0,
      'quiz_marks': '',
      'total_marks': '',
    },
  };

  @override
  void initState() {
    var assignment = widget.lecture.assignment!;
    assignmentQuestions = assignment.questions;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  localization.close_assignment,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text(
                  localization.close_assignment_alert_message,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          localization.close,
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          localization.cancel,
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
          icon: const Icon(
            Icons.close,
            color: Colors.redAccent,
          ),
        ),
        title: SizedBox(
          height: 50,
          child: Hero(
              tag: 'logo',
              child: Image.asset(
                'images/Icon/appIcon.png',
              )),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StepProgressIndicator(
                totalSteps: assignmentQuestions.length,
                currentStep: currentStep,
                selectedColor: currentStep != assignmentQuestions.length
                    ? const Color(0xff098FEA)
                    : const Color(0xff08CE5D),
                unselectedColor: Colors.grey,
              ),
              const SizedBox(
                height: 20.0,
              ),

              const SizedBox(
                height: 10.0,
              ),
              // assignment questions
              assignmentQuestion(
                  question: assignmentQuestions[currentStep - 1]),
              const SizedBox(
                height: 100.0,
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            color: CupertinoColors.black,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                topLeft: Radius.circular(10.0))),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
              ),
              onPressed: (currentStep > 1)
                  ? () {
                      setState(() {
                        currentStep -= 1;
                      });
                    }
                  : null,
              child: Row(
                children: [
                  const Icon(
                    Icons.arrow_back_ios,
                    size: 20.0,
                  ),
                  Text(
                    localization.back,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: currentStep < assignmentQuestions.length
                    ? const Color(0xff098FEA)
                    : const Color(0xff08CE5D),
              ),
              onPressed: () {
                setState(
                  () {
                    if (selectedAnswer != null) {
                      answers[assignmentQuestions[currentStep - 1].id] =
                          assignmentQuestions[currentStep - 1]
                              .choices[selectedAnswer!];

                      answersIndexes[assignmentQuestions[currentStep - 1].id] =
                          selectedAnswer;
                    }

                    if (currentStep < assignmentQuestions.length) {
                      // Going to the next question
                      currentStep += 1;

                      // resetting selected answer
                      selectedAnswer = null;
                    } else {
                      // assignment is finished
                      if (assignmentQuestions.length != answers.length) {
                        ShowToast('finish The last one', ToastGravity.CENTER);
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              localization.assignment_submission,
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Text(
                              localization.assignment_submission_alert_message,
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      if (!answersIndexes.containsValue(null)) {
                                        int assignmentMark = 0;
                                        int total = 0;

                                        for (var question
                                            in assignmentQuestions) {
                                          total += question.mark;
                                        }

                                        // Evaluate the assignment marks
                                        for (int i = 0;
                                            i < answersIndexes.length;
                                            i++) {
                                          if (answersIndexes[
                                                  assignmentQuestions[i].id] ==
                                              (int.parse(assignmentQuestions[i]
                                                      .answer) -
                                                  1)) {
                                            assignmentMark +=
                                                assignmentQuestions[i].mark;
                                            rightAnswers += 1;
                                            print('right');
                                          } else {
                                            wrongAnswers += 1;
                                            print('wrong');
                                          }
                                        }

                                        finalAnswers[UserID.userID!.uid]
                                            ['right_answers'] = rightAnswers;
                                        finalAnswers[UserID.userID!.uid]
                                            ['wrong_answers'] = wrongAnswers;

                                        Navigator.of(context).pop();
                                        print(answersIndexes);
                                        try {
                                          //Submission
                                          for (int i = 0;
                                              i < assignmentQuestions.length;
                                              i++) {
                                            print(answersIndexes[
                                                assignmentQuestions[i].id]);
                                            finalAnswers[UserID.userID!.uid]
                                                    ['assignment']
                                                .add({
                                              'question ${i + 1}':
                                                  assignmentQuestions[i].text,
                                              'right_answer':
                                                  assignmentQuestions[i].answer,
                                              'student_answer': answersIndexes[
                                                      assignmentQuestions[i]
                                                          .id]! +
                                                  1,
                                              'mark':
                                                  assignmentQuestions[i].mark,
                                            });
                                          }

                                          // student assignment marks
                                          finalAnswers[UserID.userID!.uid]
                                                  ['assignment_marks'] =
                                              '$assignmentMark / $total';

                                          finalAnswers[UserID.userID!.uid]
                                                  ['total_marks'] =
                                              '${total + widget.lecture.assignment!.stepsMarks}';

                                          showLoadingDialog(context);
                                          YearsData.sendAssignment(
                                              assignment: finalAnswers);
                                          Navigator.of(context).pop();

                                          //get score
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text(
                                                localization.assignment_mark,
                                                style: const TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              content: Text(
                                                '$assignmentMark / $total',
                                                style: const TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                ),
                                              ),
                                              actions: [
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .centerEnd,
                                                  child: TextButton(
                                                      child: Text(
                                                          localization.okay),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();
                                                      }),
                                                ),
                                              ],
                                            ),
                                          );

                                          // if (!YearsData.checkAssignmentExistence()) {
                                          //
                                          // } else {
                                          //   showDialog(
                                          //     context: context,
                                          //     builder: (context) => AlertDialog(
                                          //       content: const Text(
                                          //         'Sorry!, you already took this assignment!',
                                          //         style: TextStyle(
                                          //           fontSize: 20.0,
                                          //           fontWeight: FontWeight.bold,
                                          //           color: Colors.green,
                                          //         ),
                                          //       ),
                                          //       actions: [
                                          //         Align(
                                          //           alignment: AlignmentDirectional
                                          //               .centerEnd,
                                          //           child: TextButton(
                                          //               child: const Text('Okay'),
                                          //               onPressed: () {
                                          //                 Navigator.of(context).pop();
                                          //                 Navigator.of(context).pop();
                                          //               }),
                                          //         ),
                                          //       ],
                                          //     ),
                                          //   );
                                          // }
                                        } catch (error) {
                                          print(error.toString());
                                          print(answersIndexes);
                                        }
                                      } else {
                                        Navigator.of(context).pop();
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            content: Text(
                                              localization.questions_not_done,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0,
                                              ),
                                            ),
                                            actions: [
                                              Align(
                                                alignment: AlignmentDirectional
                                                    .centerEnd,
                                                child: TextButton(
                                                    child:
                                                        Text(localization.okay),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    }),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(
                                      localization.finish_assignment,
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20.0),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      localization.cancel,
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      }
                    }
                  },
                );
              },
              child: Row(
                children: [
                  Text(
                    currentStep < assignmentQuestions.length
                        ? localization.next
                        : localization.finish_assignment,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 15.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget assignmentQuestion({required QuestionModel question}) {
    var localization = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '#$currentStep ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.orange,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      question.text,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    '${localization.marks}: ${question.mark} ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Color(0xff098FEA),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15.0,
              ),
              question.image != null
                  ? Center(
                      child: Column(
                        children: [
                          Image.network(
                            question.image!,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(
                      height: 15.0,
                    ),
            ],
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 10.0,
            );
          },
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedAnswer = index;
                  answersIndexes[assignmentQuestions[currentStep - 1].id] =
                      selectedAnswer;
                });
                print(answersIndexes);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 15.0),
                decoration: BoxDecoration(
                  //selectedAnswer == index && selectedAnswer != null ||

                  // index of (answer) -> id -> 123

                  // answers.values
                  //     .where((answerID) =>
                  // answerID ==
                  //     answers[quizQuestions[currentStep - 1]
                  //         .id])
                  //     .first ==
                  //     index
                  color:
                      answersIndexes[assignmentQuestions[currentStep - 1].id] ==
                                  index &&
                              answersIndexes[
                                      assignmentQuestions[currentStep - 1]
                                          .id] !=
                                  null
                          ? const Color(0xff08CE5D)
                          : Colors.black,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xff098FEA),
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                          color: answersIndexes[
                                          assignmentQuestions[currentStep - 1]
                                              .id] ==
                                      index &&
                                  answersIndexes[
                                          assignmentQuestions[currentStep - 1]
                                              .id] !=
                                      null
                              ? Colors.white
                              : Colors.white,
                          fontWeight: answersIndexes[
                                          assignmentQuestions[currentStep - 1]
                                              .id] ==
                                      index &&
                                  answersIndexes[
                                          assignmentQuestions[currentStep - 1]
                                              .id] !=
                                      null
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: Text(
                        question.choices[index],
                        style: TextStyle(
                          color: answersIndexes[
                                          assignmentQuestions[currentStep - 1]
                                              .id] ==
                                      index &&
                                  answersIndexes[
                                          assignmentQuestions[currentStep - 1]
                                              .id] !=
                                      null
                              ? Colors.white
                              : Colors.white,
                          fontWeight: answersIndexes[
                                          assignmentQuestions[currentStep - 1]
                                              .id] ==
                                      index &&
                                  answersIndexes[
                                          assignmentQuestions[currentStep - 1]
                                              .id] !=
                                      null
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: question.choices.length,
        ),
      ],
    );
  }
}
