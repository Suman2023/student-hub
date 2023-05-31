import 'package:dio/dio.dart';
import 'package:student_hub/models/user_auth_model.dart';

class AcountService {
  final Dio _dio = Dio();
  final String BASE_URL = "http://10.0.2.2:8000/accounts";

// Sign in the user

  Future<void> signin({required String email, required String password, required String csrftoken}) async {
    try {
      final result = await _dio.postUri(Uri.parse('$BASE_URL/signin/'),
          data: {
            "email": email,
            "password": password,
          },
          options: Options(
              headers: {'X-CSRFToken': csrftoken}));
      print(result);
    } catch (e) {
      print("Error $e");
    }
  }

  Future<UserAuthResponse?> signup(
      {required String email, required String password}) async {
    try {
      final result = await _dio.postUri(
        Uri.parse('$BASE_URL/signup/'),
        data: {
          "email": email,
          "password": password,
        },
      );
      final csrftoken =
          result.headers.value("set-cookie")!.split(";")[0].split("=")[1];
      final response = UserAuthResponse(
          email: email, password: password, csrftoken: csrftoken);
      return response;
    } catch (e) {
      print("Error $e");
    }
    return null;
  }
}
