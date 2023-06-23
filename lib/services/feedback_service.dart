import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../database/account_db_helper.dart';

class FeedbackService {
  Dio? _dio;
  FeedbackService() {
    BaseOptions options = BaseOptions(
      baseUrl: "${dotenv.env['BASE_URL']}/feedback",
      connectTimeout: const Duration(seconds: 5),
    );
    _dio ??= Dio(options);
  }

  Future<bool> sendFeedback({String? filePath, required String text}) async {
    try {
      FormData formData = FormData.fromMap({
        "imagefile": filePath != null
            ? await MultipartFile.fromFile(
                filePath,
                filename: filePath.split('/').last,
              )
            : null,
        "feedback": text
      });

      final authdetails = await AccountDbHelper.getCurrentUserCred();

      if (authdetails != null) {
        final csrftoken = authdetails["csrftoken"],
            sessionid = authdetails["sessionid"];
        final response = await _dio!.post(
          "/submit/",
          data: formData,
          options: Options(
            headers: {
              'Cookie': "csrftoken=$csrftoken; sessionid=$sessionid",
              'X-CSRFToken': csrftoken
            },
            receiveTimeout: const Duration(seconds: 5),
          ),
        );
        if (response.statusCode != null && response.statusCode! < 300) {
          return true;
        }
      }
    } catch (e) {
      print("Error in sending feedback $e");
    }
    return false;
  }
}
