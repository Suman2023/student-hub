import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:student_hub/models/user_auth_model.dart';

import '../database/account_db_helper.dart';

class AcountService {
  Dio? _dio;

  AcountService() {
    BaseOptions options = BaseOptions(
      baseUrl:
          "${dotenv.env['BASE_URL']}/accounts",
      connectTimeout: const Duration(seconds: 5),
    );
    _dio ??= Dio(options);
  }

  Future<UserAuthResponse> signin(
      {required String email,
      required String password,
      String? csrftoken}) async {
    String? newcsrf, newsessionid;
    try {
      final result = await _dio!.post("/signin/",
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
      if (newcsrf != null && newsessionid != null) {
        await AccountDbHelper.saveCred(email, password, newcsrf, newsessionid);
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
      final result = await _dio!.post(
        "/signup/",
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
    final response = await _dio!.get(
      "/signout",
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

  static bool validateEmail(String email) {
    const pattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  static bool validatePassword(String password) {
    const pattern =
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(password);
  }
}
