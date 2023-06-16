import 'dart:convert';

List<TestQuestionsModel> testQuestionsModelFromJson(String str) => List<TestQuestionsModel>.from(json.decode(str).map((x) => TestQuestionsModel.fromJson(x)));

String testQuestionsModelToJson(List<TestQuestionsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TestQuestionsModel {
    int id;
    String testname;
    String question;
    String optionA;
    String optionB;
    String optionC;
    String optionD;

    TestQuestionsModel({
        required this.id,
        required this.testname,
        required this.question,
        required this.optionA,
        required this.optionB,
        required this.optionC,
        required this.optionD,
    });

    factory TestQuestionsModel.fromJson(Map<String, dynamic> json) => TestQuestionsModel(
        id: json["id"],
        testname: json["testname"],
        question: json["question"],
        optionA: json["option_a"],
        optionB: json["option_b"],
        optionC: json["option_c"],
        optionD: json["option_d"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "testname": testname,
        "question": question,
        "option_a": optionA,
        "option_b": optionB,
        "option_c": optionC,
        "option_d": optionD,
    };
}
