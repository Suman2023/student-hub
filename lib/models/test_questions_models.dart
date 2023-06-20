import 'dart:convert';

TestQuestionsModel testQuestionsModelFromJson(String str) => TestQuestionsModel.fromJson(json.decode(str));

String testQuestionsModelToJson(TestQuestionsModel data) => json.encode(data.toJson());

class TestQuestionsModel {
    int id;
    String testname;
    List<Question> questions;

    TestQuestionsModel({
        required this.id,
        required this.testname,
        required this.questions,
    });

    factory TestQuestionsModel.fromJson(Map<String, dynamic> json) => TestQuestionsModel(
        id: json["id"],
        testname: json["testname"],
        questions: List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "testname": testname,
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
    };
}

class Question {
    int id;
    String question;
    String optionA;
    String optionB;
    String optionC;
    String optionD;

    Question({
        required this.id,
        required this.question,
        required this.optionA,
        required this.optionB,
        required this.optionC,
        required this.optionD,
    });

    factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"],
        question: json["question"],
        optionA: json["option_a"],
        optionB: json["option_b"],
        optionC: json["option_c"],
        optionD: json["option_d"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "option_a": optionA,
        "option_b": optionB,
        "option_c": optionC,
        "option_d": optionD,
    };
}
