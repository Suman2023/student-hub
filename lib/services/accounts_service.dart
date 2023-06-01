import 'package:dio/dio.dart';
import 'package:student_hub/models/user_auth_model.dart';

class AcountService {
  final Dio _dio = Dio();
  final String BASE_URL = "http://10.0.2.2:8000/accounts";

// Sign in the user

  Future<Map<String, dynamic>?> signin(
      {required String email,
      required String password,
      required String csrftoken}) async {
    try {
      final result = await _dio.postUri(Uri.parse('$BASE_URL/signin/'),
          data: {
            "email": email,
            "password": password,
          },
          options: Options(headers: {'X-CSRFToken': csrftoken}));

      String? newcsrf, newsessionid;
      for (String element in result.headers['set-cookie']!) {
        if (element.contains("csrftoken")) {
          newcsrf = element.split(";")[0].split("=")[1];
        }
        if (element.contains("sessionid")) {
          newsessionid = element.split(";")[0].split("=")[1];
        }
      }
      final cookie = {"csrftoken": newcsrf, "sessionid": newsessionid};
      return cookie;
    } catch (e) {
      print("Error in signin $e");
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
      String csrftoken =
          result.headers.value("set-cookie")!.split(";")[0].split("=")[1];
      print("csrf before signin: $csrftoken");
      Map<String,dynamic>? cookie =
          await signin(email: email, password: password, csrftoken: csrftoken);
      print("csrf After signin: $cookie");
      if (cookie != null) {
        final response = UserAuthResponse(
            email: email, password: password, csrftoken: cookie['csrftoken'], sessionid: cookie['sessionid']);
        return response;
      }
    } catch (e) {
      print("Error in Singnup $e");
    }
    return null;
  }
}
