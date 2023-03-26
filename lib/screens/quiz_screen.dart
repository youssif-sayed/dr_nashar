import 'package:dr_nashar/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../models/question_model.dart';
import '../user/UserID.dart';
import '../user/yearsData.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentStep = 1;
  int? selectedAnswer;
  Map<int, int?> answers = {}; // question id : answer id
  Map<int, int?> answersIndexes = {};
  List<QuestionModel> quizQuestions = [];
  int rightAnswers = 0;
  int wrongAnswers = 0;
  Map<String, dynamic> finalAnswers = {
    UserID.userID!.uid: {
      'quiz_name': '${YearsData.selectedSubject} quiz',
      'quiz': [],
      'right_answers': 0,
      'wrong_answers': 0,
      'total_marks': '',
    },
  };

  @override
  void initState() {
    var quiz = YearsData.subjectQuiz[0]
        ['${YearsData.selectedYear}-${YearsData.selectedSubject}-quiz'];
    //var question in quiz
    for (int i = 0; i < quiz.length; i++) {
      quizQuestions.add(
        QuestionModel(
          questionID: quiz[i]['question_id'],
          questionText: quiz[i]['question_text'],
          questionImage: quiz[i]['question_image'],
          mark: quiz[i]['mark'],
          answers: [
            Answer(
                answerID: quiz[i]['answer'][0]['answer_id'],
                answerText: quiz[i]['answer'][0]['answer_text']),
            Answer(
                answerID: quiz[i]['answer'][1]['answer_id'],
                answerText: quiz[i]['answer'][1]['answer_text']),
            Answer(
                answerID: quiz[i]['answer'][2]['answer_id'],
                answerText: quiz[i]['answer'][2]['answer_text']),
            Answer(
                answerID: quiz[i]['answer'][3]['answer_id'],
                answerText: quiz[i]['answer'][3]['answer_text']),
          ],
          rightAnswer: quiz[i]['right_answer'],
        ),
      );
    }

    for (var question in quizQuestions) {
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
                  localization.close_quiz,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text(
                  localization.close_quiz_alert_message,
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
                totalSteps: quizQuestions.length,
                currentStep: currentStep,
                selectedColor: currentStep != quizQuestions.length
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
              // Quiz questions
              quizQuestion(question: quizQuestions[currentStep - 1]),
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
                backgroundColor: currentStep < quizQuestions.length
                    ? const Color(0xff098FEA)
                    : const Color(0xff08CE5D),
              ),
              onPressed: () {
                setState(() {
                  if (selectedAnswer != null) {
                    answers[quizQuestions[currentStep - 1].questionID] =
                        quizQuestions[currentStep - 1]
                            .answers[selectedAnswer!]
                            .answerID;

                    answersIndexes[quizQuestions[currentStep - 1].questionID] =
                        selectedAnswer;
                  }

                  if (currentStep < quizQuestions.length) {
                    // Going to the next question
                    currentStep += 1;

                    // resetting selected answer
                    selectedAnswer = null;
                  } else {
                    // Quiz is finished
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text(
                          'Quiz submission',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Text(
                          localization.quiz_submission_alert_message,
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
                                    int quizMark = 0;
                                    int total = 0;

                                    for (var question in quizQuestions) {
                                      total += question.mark;
                                    }

                                    // Evaluate the quiz marks
                                    for (int i = 0;
                                        i < answersIndexes.length;
                                        i++) {
                                      if (answersIndexes[quizQuestions[i]
                                                  .questionID]! +
                                              1 ==
                                          int.parse(
                                              quizQuestions[i].rightAnswer)) {
                                        quizMark += quizQuestions[i].mark;
                                        rightAnswers += 1;
                                      } else {
                                        wrongAnswers += 1;
                                      }
                                    }

                                    finalAnswers[UserID.userID!.uid]['right_answers'] = rightAnswers;
                                    finalAnswers[UserID.userID!.uid]['wrong_answers'] = wrongAnswers;

                                    Navigator.of(context).pop();

                                    try {
                                      //Submission
                                      for (int i = 0;
                                          i < quizQuestions.length;
                                          i++) {
                                        finalAnswers[UserID.userID!.uid]['quiz']
                                            .add({
                                          'question ${i + 1}':
                                              quizQuestions[i].questionText,
                                          'right_answer':
                                              quizQuestions[i].rightAnswer,
                                          'student_answer': answersIndexes[
                                                  quizQuestions[i]
                                                      .questionID]! +
                                              1,
                                          'mark': quizQuestions[i].mark,
                                        });
                                      }

                                      // student total marks
                                      finalAnswers[UserID.userID!.uid]
                                              ['total_marks'] =
                                          '$quizMark / $total';
                                      print(finalAnswers);
                                      showLoadingDialog(context);
                                      YearsData.sendQuiz(quiz: finalAnswers);
                                      Navigator.of(context).pop();

                                      //get score
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                            localization.quiz_mark,
                                            style: const TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          content: Text(
                                            '$quizMark / $total',
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
                                                  child:
                                                      Text(localization.okay),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                  }),
                                            ),
                                          ],
                                        ),
                                      );

                                      // if (!YearsData.checkQuizExistence()) {
                                      //
                                      // } else {
                                      //   showDialog(
                                      //     context: context,
                                      //     builder: (context) => AlertDialog(
                                      //       content: const Text(
                                      //         'Sorry!, you already took this quiz!',
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
                                        content: Text(
                                          localization.questions_not_done,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        actions: [
                                          Align(
                                            alignment:
                                                AlignmentDirectional.centerEnd,
                                            child: TextButton(
                                                child: Text(localization.okay),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
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
                    currentStep < quizQuestions.length
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

  Widget quizQuestion({required QuestionModel question}) {
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
                      question.questionText,
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
                  answersIndexes[quizQuestions[currentStep - 1].questionID] =
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
                                  quizQuestions[currentStep - 1].questionID] ==
                              index &&
                          answersIndexes[
                                  quizQuestions[currentStep - 1].questionID] !=
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
                          color: answersIndexes[quizQuestions[currentStep - 1]
                                          .questionID] ==
                                      index &&
                                  answersIndexes[quizQuestions[currentStep - 1]
                                          .questionID] !=
                                      null
                              ? Colors.white
                              : Colors.white,
                          fontWeight: answersIndexes[
                                          quizQuestions[currentStep - 1]
                                              .questionID] ==
                                      index &&
                                  answersIndexes[quizQuestions[currentStep - 1]
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
                          color: answersIndexes[quizQuestions[currentStep - 1]
                                          .questionID] ==
                                      index &&
                                  answersIndexes[quizQuestions[currentStep - 1]
                                          .questionID] !=
                                      null
                              ? Colors.white
                              : Colors.white,
                          fontWeight: answersIndexes[
                                          quizQuestions[currentStep - 1]
                                              .questionID] ==
                                      index &&
                                  answersIndexes[quizQuestions[currentStep - 1]
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
