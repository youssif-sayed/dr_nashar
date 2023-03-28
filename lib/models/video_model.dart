
import 'package:dr_nashar/models/question_model.dart';
import 'package:equatable/equatable.dart';

class LectureModel extends Equatable {
  const LectureModel(
      {required this.image,
      required this.documents,
      required this.name,
      required this.price,
      required this.videos,
      required this.id,
      this.assignment,
      this.quiz});

  final String image;
  final List<Document> documents;
  final List<Video> videos;
  final String name;
  final double price;
  final String id;
  final Assignment? assignment;
  final Quiz? quiz;

  LectureModel copyWith(
          {String? image,
          List<Document>? documents,
          List<Video>? videos,
          String? name,
          double? price,
          String? id,
          Assignment? assignment,
          Quiz? quiz}) =>
      LectureModel(
          image: image ?? this.image,
          documents: documents ?? this.documents,
          videos: videos ?? this.videos,
          name: name ?? this.name,
          price: price ?? this.price,
          id: id ?? this.id,
          assignment: assignment ?? this.assignment,
          quiz: quiz ?? this.quiz);

  factory LectureModel.fromJson(Map<String, dynamic> json) => LectureModel(
        image: json["image"],
        documents: List<Document>.from(
            json["documents"].map((x) => Document.fromJson(x))),
        videos: List<Video>.from(
            json["videos"].map((x) => Video.fromJson(x))),
        name: json["name"],
        price: json["price"],
        id: json["id"],
        assignment: json["assignment"] == null
            ? null
            : Assignment.fromJson(json["assignment"]),
        quiz: json["quiz"] == null ? null : Quiz.fromJson(json["quiz"]),
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "documents": List<dynamic>.from(documents.map((x) => x.toJson())),
        "videos": List<dynamic>.from(videos.map((x) => x.toJson())),
        "name": name,
        "price": price,
        "id": id,
        "assignment": assignment?.toJson(),
        "quiz": quiz?.toJson()
      };

  @override
  List<Object?> get props => [assignment];
}

class Assignment extends Equatable {
  const Assignment({
    required this.questions,
    required this.stepsMarks,
  });

  final List<QuestionModel> questions;
  final int stepsMarks;

  Assignment copyWith({
    List<QuestionModel>? questions,
    int? stepsMarks,
  }) =>
      Assignment(
        questions: questions ?? this.questions,
        stepsMarks: stepsMarks ?? this.stepsMarks,
      );

  factory Assignment.fromJson(Map<String, dynamic> json) => Assignment(
        questions: List<QuestionModel>.from(
            json["questions"].map((x) => QuestionModel.fromJson(x))),
        stepsMarks: json["steps_marks"],
      );

  Map<String, dynamic> toJson() => {
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
        "steps_marks": stepsMarks,
      };

  @override
  List<Object?> get props => [questions, stepsMarks];
}

class Quiz extends Equatable {
  const Quiz({
    required this.questions,
    required this.stepsMarks,
  });

  final List<QuestionModel> questions;
  final int stepsMarks;

  Quiz copyWith({
    List<QuestionModel>? questions,
    int? stepsMarks,
  }) =>
      Quiz(
        questions: questions ?? this.questions,
        stepsMarks: stepsMarks ?? this.stepsMarks,
      );

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
        questions: List<QuestionModel>.from(
            json["questions"].map((x) => QuestionModel.fromJson(x))),
        stepsMarks: json["steps_marks"],
      );

  Map<String, dynamic> toJson() => {
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
        "steps_marks": stepsMarks,
      };

  @override
  List<Object?> get props => [questions, stepsMarks];
}

class Document {
  Document({
    required this.name,
    required this.src,
  });

  final String name;
  final String src;

  Document copyWith({
    String? name,
    String? src,
  }) =>
      Document(
        name: name ?? this.name,
        src: src ?? this.src,
      );

  factory Document.fromJson(Map<String, dynamic> json) => Document(
        name: json["name"],
        src: json["src"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "src": src,
      };
}

class Video {
  Video({
    this.name,
    this.url,
  });

  final String? name;
  final String? url;

  Video copyWith({
    String? name,
    String? url,
  }) =>
      Video(
        name: name ?? this.name,
        url: url ?? this.url,
      );
 
  factory Video.fromJson(Map<String, dynamic> json) => Video(
        name: json["name"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
      };
}
