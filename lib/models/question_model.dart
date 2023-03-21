class QuestionModel {
  int questionID;
  String questionText;
  String questionImage;
  List<Answer> answers;
  String rightAnswer;
  int mark;

  QuestionModel({
    required this.questionID,
    required this.questionText,
    required this.questionImage,
    required this.answers,
    required this.rightAnswer,
    this.mark = 1,
  });

  Map<String, dynamic> toMap() {
    List qsAnswers = [];

    for (int i = 0; i < answers.length; i++) {
      qsAnswers.add(answers[i].toMap());
    }

    return {
      'question_id': questionID,
      'question_text': questionText,
      'question_image': questionImage,
      'answer': qsAnswers,
      'right_answer': rightAnswer,
      'mark': mark,
    };
  }
}

class Answer {
  int answerID;
  String answerText;

  Answer({required this.answerID, required this.answerText});

  Map<String, dynamic> toMap() {
    return {
      'answer_id': answerID,
      'answer_text': answerText,
    };
  }

  static Answer fromMap(Map<String, dynamic> answer) {
    return Answer(
        answerID: answer['answer_id'], answerText: answer['answer_text']);
  }
}
