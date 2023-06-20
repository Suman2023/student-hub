import 'dart:convert';

List<TestModel> testModelFromJson(String str) =>
    List<TestModel>.from(json.decode(str).map((x) => TestModel.fromJson(x)));

String testModelToJson(List<TestModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TestModel {
  int id, questionCount;
  String testname;

  TestModel({
    required this.id,
    required this.testname,
    required this.questionCount,
  });

  factory TestModel.fromJson(Map<String, dynamic> json) => TestModel(
      id: json["id"],
      testname: json["name"],
      questionCount: json["total_question"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": testname,
        "total_question": questionCount,
      };
}
