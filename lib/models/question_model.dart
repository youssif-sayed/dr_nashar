class QuestionModel {
  QuestionModel({
    required this.id,
    required this.text,
    required this.choices,
    required this.answer,
    required this.image,
    required this.mark,
  });
  final String id;
  final String text;
  final List<String> choices;
  final String answer;
  final String? image;
  final int mark;

  QuestionModel copyWith({
    String? id,
    String? text,
    List<String>? choices,
    String? answer,
    String? image,
    int? mark,
  }) =>
      QuestionModel(
        id: id ?? this.id,
        text: text ?? this.text,
        choices: choices ?? this.choices,
        answer: answer ?? this.answer,
        image: image ?? this.image,
        mark: mark ?? this.mark,
      );

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
        id: json['id'],
        text: json["text"],
        choices: List<String>.from(json["choices"].map((x) => x)),
        answer: json["answer"],
        image: json["image"],
        mark: json["mark"].toInt(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "choices": List<dynamic>.from(choices.map((x) => x)),
        "answer": answer,
        "image": image,
        "mark": mark,
      };
}
