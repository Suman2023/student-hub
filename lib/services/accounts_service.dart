import 'package:dio/dio.dart';
import 'package:student_hub/models/user_auth_model.dart';

import '../database/account_db_helper.dart';

class AcountService {
  final Dio _dio = Dio();
  final String BASE_URL = "https://f4be-2405-201-a80e-d822-d1fa-7a43-ba11-28e2.ngrok-free.app/accounts";
// Sign in the user

  Future<UserAuthResponse> signin(
      {required String email,
      required String password,
      String? csrftoken}) async {
    String? newcsrf, newsessionid;
    try {
      final result = await _dio.postUri(Uri.parse('$BASE_URL/signin/'),
          data: {
            "email": email,
            "password": password,
          },
          options: csrftoken == null
              ? null
              : Options(headers: {'X-CSRFToken': csrftoken}));

      for (String element in result.headers['set-cookie']!) {
        if (element.contains("csrftoken")) {
          newcsrf = element.split(";")[0].split("=")[1];
        }
        if (element.contains("sessionid")) {
          newsessionid = element.split(";")[0].split("=")[1];
        }
      }
    } catch (e) {
      print("Error in signin $e");
    }
    final authuser = UserAuthResponse(
        email: email,
        password: password,
        csrftoken: newcsrf ?? "",
        sessionid: newsessionid ?? "");
    return authuser;
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
      UserAuthResponse userAuthResponse =
          await signin(email: email, password: password, csrftoken: csrftoken);

      return userAuthResponse;
    } catch (e) {
      print("Error in Singnup $e");
    }
    return null;
  }

  Future<void> signOut() async {
    final authdetails = await AccountDbHelper.getCurrentUserCred();

    final csrftoken = authdetails!["csrftoken"],
        sessionid = authdetails["sessionid"];
    final response = await _dio.get(
      "$BASE_URL/signout",
      options: Options(
        headers: {
          'Cookie': "csrftoken=$csrftoken; sessionid=$sessionid",
          'X-CSRFToken': csrftoken
        },
      ),
    );
    if (response.data != null) {
      await AccountDbHelper.clearAccountTable();
    }
  }

  Future<Map<String, dynamic>?> isAuthenticated() async {
    final auth = await AccountDbHelper.getCurrentUserCred();
    return auth;
  }
}
