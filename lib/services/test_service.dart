import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:student_hub/models/test_questions_models.dart';
import '../database/account_db_helper.dart';
import '../models/test_models.dart';
import 'dart:developer' as devtools show log;

extension Log on Object {
  log() => devtools.log(toString());
}

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
    List<TestModel> result = [];
    try {
      final authdetails = await AccountDbHelper.getCurrentUserCred();

      if (authdetails != null) {
        final csrftoken = authdetails["csrftoken"],
            sessionid = authdetails["sessionid"];
        final response = await _dio!.get(
          "/getalltests",
          options: Options(
            headers: {
              'Cookie': "csrftoken=$csrftoken; sessionid=$sessionid",
              'X-CSRFToken': csrftoken
            },
            receiveTimeout: const Duration(seconds: 5),
          ),
        );
        print(response.data);
        return testModelFromJson(json.encode(response.data));
      }
    } catch (e) {
      e.log();
    }
    return result;
  }

  Future<TestQuestionsModel?> getAllQuestions({required int testid}) async {
    try {
      final authdetails = await AccountDbHelper.getCurrentUserCred();
      if (authdetails != null) {
        final csrftoken = authdetails["csrftoken"],
            sessionid = authdetails["sessionid"];
        final response = await _dio!.get(
          "/getallquestions/$testid",
          options: Options(
            headers: {
              'Cookie': "csrftoken=$csrftoken; sessionid=$sessionid",
              'X-CSRFToken': csrftoken,
            },
            receiveTimeout: const Duration(
              seconds: 5,
            ),
          ),
        );
        print(response.data);
        return testQuestionsModelFromJson(json.encode(response.data));
      }
    } catch (e) {
      e.log();
    }
    return null;
  }

  Future<bool> submitTest({required List<String> ansList, required int testid}) async {
    bool success = false;
    try {
      final authdetails = await AccountDbHelper.getCurrentUserCred();

      if (authdetails != null) {
        final csrftoken = authdetails["csrftoken"],
            sessionid = authdetails["sessionid"];
        final response = await _dio!.post(
          "/submit",
          data: {"answers": ansList, "testid": testid},
          options: Options(
            headers: {
              'Cookie': "csrftoken=$csrftoken; sessionid=$sessionid",
              'X-CSRFToken': csrftoken
            },
            receiveTimeout: const Duration(seconds: 5),
          ),
        );
        success = response.statusCode != null && response.statusCode! < 300 ? true : false;
        if(!success){
          throw response.data;
        }
      }
    } catch (e) {
      e.log();
    }
    return success;
  }
}
