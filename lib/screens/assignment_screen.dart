import 'package:dr_nashar/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../models/question_model.dart';
import '../user/UserID.dart';
import '../user/yearsData.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({Key? key}) : super(key: key);

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  int currentStep = 1;
  int? selectedAnswer;
  Map<int, int?> answers = {}; // question id : answer id
  Map<int, int?> answersIndexes = {};
  List<QuestionModel> assignmentQuestions = [];
  int rightAnswers = 0;
  int wrongAnswers = 0;
  Map<String, dynamic> finalAnswers = {
    UserID.userID!.uid: {
      'assignment_name': '${YearsData.selectedSubject} assignment',
      'assignment': [],
      'right_answers': 0,
      'wrong_answers': 0,
      'total_marks': '',
    },
  };

  @override
  void initState() {
    var assignment = YearsData.subjectAssignment[0]
    ['${YearsData.selectedYear}-${YearsData.selectedSubject}-assignment'];
    //var question in assignment
    for (int i = 0; i < assignment.length; i++) {
      assignmentQuestions.add(
        QuestionModel(
          questionID: assignment[i]['question_id'],
          questionText: assignment[i]['question_text'],
          questionImage: assignment[i]['question_image'],
          mark: assignment[i]['mark'],
          answers: [
            Answer(
                answerID: assignment[i]['answer'][0]['answer_id'],
                answerText: assignment[i]['answer'][0]['answer_text']),
            Answer(
                answerID: assignment[i]['answer'][1]['answer_id'],
                answerText: assignment[i]['answer'][1]['answer_text']),
            Answer(
                answerID: assignment[i]['answer'][2]['answer_id'],
                answerText: assignment[i]['answer'][2]['answer_text']),
            Answer(
                answerID: assignment[i]['answer'][3]['answer_id'],
                answerText: assignment[i]['answer'][3]['answer_text']),
          ],
          rightAnswer: assignment[i]['right_answer'],
        ),
      );
    }

    for (var question in assignmentQuestions) {
      answers.addAll({
        question.questionID: null,
      });
      answersIndexes.addAll({
        question.questionID: null,
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                title: const Text(
                  'Close the assignment',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: const Text(
                  'are you sure you want to exit from this assignment?',
                  style: TextStyle(
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
                        child: const Text(
                          'Close',
                          style: TextStyle(
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
                        child: const Text(
                          'cancel',
                          style: TextStyle(
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
              assignmentQuestion(question: assignmentQuestions[currentStep - 1]),
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
              child:  const Row(
                children: [
                  Icon(Icons.arrow_back_ios, size: 20.0,),
                  Text('Back', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),),
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
                setState(() {
                  if (selectedAnswer != null) {
                    answers[assignmentQuestions[currentStep - 1].questionID] =
                        assignmentQuestions[currentStep - 1]
                            .answers[selectedAnswer!]
                            .answerID;

                    answersIndexes[assignmentQuestions[currentStep - 1]
                        .questionID] = selectedAnswer;
                  }

                  if (currentStep < assignmentQuestions.length) {
                    // Going to the next question
                    currentStep += 1;

                    // resetting selected answer
                    selectedAnswer = null;
                  } else {
                    // assignment is finished
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text(
                          'Assignment submission',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: const Text(
                          'are you sure you want to finish this assignment?',
                          style: TextStyle(
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

                                    for (var question in assignmentQuestions) {
                                      total += question.mark;
                                    }

                                    // Evaluate the assignment marks
                                    for (int i = 0;
                                    i < answersIndexes.length;
                                    i++) {
                                      if (answersIndexes[assignmentQuestions[i]
                                          .questionID]! +
                                          1 ==
                                          int.parse(
                                              assignmentQuestions[i].rightAnswer)) {
                                        assignmentMark += assignmentQuestions[i].mark;
                                        rightAnswers += 1;
                                      } else {
                                        wrongAnswers += 1;
                                      }
                                    }

                                    finalAnswers['right_answer'] = rightAnswers;
                                    finalAnswers['wrong_answer'] = wrongAnswers;

                                    Navigator.of(context).pop();


                                    try {
                                      //Submission
                                      for (int i = 0;
                                      i < assignmentQuestions.length;
                                      i++) {
                                        finalAnswers[UserID.userID!.uid]
                                        ['assignment']
                                            .add({
                                          'question ${i + 1}':
                                          assignmentQuestions[i].questionText,
                                          'right_answer':
                                          assignmentQuestions[i].rightAnswer,
                                          'student_answer': answersIndexes[
                                          assignmentQuestions[i]
                                              .questionID]! +
                                              1,
                                          'mark': assignmentQuestions[i].mark,
                                        });

                                      }

                                      // student total marks
                                      finalAnswers[UserID.userID!.uid]
                                      ['total_marks'] = '$assignmentMark / $total';


                                      showLoadingDialog(context);
                                      YearsData.sendAssignment(assignment: finalAnswers);
                                      Navigator.of(context).pop();

                                      //get score
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text(
                                            'Assignment mark',
                                            style: TextStyle(
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
                                              alignment: AlignmentDirectional
                                                  .centerEnd,
                                              child: TextButton(
                                                  child: const Text('Okay'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
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
                                    }

                                  } else {
                                    Navigator.of(context).pop();
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        content: const Text(
                                          'Please finish all the questions first.',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        actions: [
                                          Align(
                                            alignment: AlignmentDirectional
                                                .centerEnd,
                                            child: TextButton(
                                                child: const Text('Okay'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                }),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  'Finish NOW!',
                                  style: TextStyle(
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
                                child: const Text(
                                  'cancel',
                                  style: TextStyle(
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
                });
              },
              child: Row(
                children: [

                  Text(
                    currentStep < assignmentQuestions.length ? 'Next' : 'Finish', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0,),),
                  const Icon(Icons.arrow_forward_ios, size: 15.0,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget assignmentQuestion({required QuestionModel question}) {
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
                      question.questionText,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    'Marks: ${question.mark} ',
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
              question.questionImage.isNotEmpty
                  ? Center(
                child: Column(
                  children: [
                    Image.network(
                      question.questionImage,
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
                  answersIndexes[assignmentQuestions[currentStep - 1].questionID] =
                      selectedAnswer;
                });
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
                  //         .questionID])
                  //     .first ==
                  //     index
                  color: answersIndexes[
                  assignmentQuestions[currentStep - 1].questionID] ==
                      index &&
                      answersIndexes[
                      assignmentQuestions[currentStep - 1].questionID] !=
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
                          color: answersIndexes[assignmentQuestions[currentStep - 1]
                              .questionID] ==
                              index &&
                              answersIndexes[assignmentQuestions[currentStep - 1]
                                  .questionID] !=
                                  null
                              ? Colors.white
                              : Colors.white,
                          fontWeight: answersIndexes[
                          assignmentQuestions[currentStep - 1]
                              .questionID] ==
                              index &&
                              answersIndexes[assignmentQuestions[currentStep - 1]
                                  .questionID] !=
                                  null
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: Text(
                        question.answers[index].answerText,
                        style: TextStyle(
                          color: answersIndexes[assignmentQuestions[currentStep - 1]
                              .questionID] ==
                              index &&
                              answersIndexes[assignmentQuestions[currentStep - 1]
                                  .questionID] !=
                                  null
                              ? Colors.white
                              : Colors.white,
                          fontWeight: answersIndexes[
                          assignmentQuestions[currentStep - 1]
                              .questionID] ==
                              index &&
                              answersIndexes[assignmentQuestions[currentStep - 1]
                                  .questionID] !=
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
          itemCount: question.answers.length,
        ),
      ],
    );
  }
}
