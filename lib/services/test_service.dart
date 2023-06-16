import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:student_hub/models/test_questions_models.dart';
import '../models/test_models.dart';

class TestService {
  Dio? _dio;

  TestService() {
    BaseOptions options = BaseOptions(
      baseUrl: "${dotenv.env['BASE_URL']}/skilltest",
      connectTimeout: const Duration(seconds: 5),
    );
    _dio ??= Dio(options);
  }

  Future<List<TestModel>> getAllTests() async {
    var tests = [
      {
        "id": 0,
        "testname": "testname 0",
        "question_count": 3,
      },
      {
        "id": 0,
        "testname": "testname 0",
        "question_count": 3,
      },
      {
        "id": 0,
        "testname": "testname 0",
        "question_count": 3,
      }
    ];

    return testModelFromJson(json.encode(tests));
  }

  Future<List<TestQuestionsModel>> getAllQuestions(
      {required int testid}) async {
    final questions = [
      {
        "id": 0,
        "testname": "testname 0",
        "question": "question 0",
        "option_a": "option_a",
        "option_b": "option_b",
        "option_c": "option_c",
        "option_d": "option_d"
      },
      {
        "id": 1,
        "testname": "testname 1",
        "question": "question 1",
        "option_a": "option_a",
        "option_b": "option_b",
        "option_c": "option_c",
        "option_d": "option_d"
      },
      {
        "id": 2,
        "testname": "testname 2",
        "question": "question 2",
        "option_a": "option_a",
        "option_b": "option_b",
        "option_c": "option_c",
        "option_d": "option_d"
      }
    ];
    // await _dio!.get("/getallquestions");

    return testQuestionsModelFromJson(json.encode(questions));
  }
}
