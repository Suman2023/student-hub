import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:student_hub/models/feeds_timeline_model.dart';

import '../database/account_db_helper.dart';
import 'dart:developer' as devtools show log;

class FeedService {
  Dio? _dio;

  FeedService() {
    BaseOptions options = BaseOptions(
      baseUrl: "${dotenv.env['BASE_URL']}/feeds",
      connectTimeout: const Duration(seconds: 5),
    );
    _dio ??= Dio(options);
  }

  Future<bool> addPost({
    String? text,
    File? imagefile,
    required String csrftoken,
    required String sessionid,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "imagefile": imagefile != null
            ? await MultipartFile.fromFile(
                imagefile.path,
                filename: imagefile.path.split('/').last,
              )
            : null,
        "text": text
      });

      final response = await _dio!.post("/addpost/",
          data: formData,
          options: Options(headers: {
            'Cookie': "csrftoken=$csrftoken; sessionid=$sessionid",
            'X-CSRFToken': csrftoken
          }));
      if (response.data != null) {
        return true;
      }
    } catch (e) {
      devtools.log(e.toString());
    }
    return false;
  }

  Future<List<FeedsTimeline>> getMyTimeline() async {
    List<FeedsTimeline> result = [];
    try {
      final authdetails = await AccountDbHelper.getCurrentUserCred();

      if (authdetails != null) {
        final csrftoken = authdetails["csrftoken"],
            sessionid = authdetails["sessionid"];
        final response = await _dio!.get(
          "/timelineposts",
          options: Options(
            headers: {
              'Cookie': "csrftoken=$csrftoken; sessionid=$sessionid",
              'X-CSRFToken': csrftoken
            },
            receiveTimeout: const Duration(seconds: 5),
          ),
        );
        for (var post in response.data) {
          result.add(
            FeedsTimeline(
              id: post['id'],
              username: post['username'],
              firstName: post['first_name'],
              lastName: post['last_name'],
              aspectratio: post['aspectratio'],
              text: post["text"],
              imageurl: post["imageurl"],
              totalLike: post["total_like"],
              likedByme: post["liked_byme"],
              createdAt: DateTime.parse(post["createdAt"]),
              updatedAt: DateTime.parse(post["updatedAt"]),
            ),
          );
        }
      }
    } catch (e) {
      devtools.log(e.toString());
    }

    return result;
  }

  Future<void> favouritePost(
      {required int postid, required bool favourite}) async {
    final authdetails = await AccountDbHelper.getCurrentUserCred();
    if (authdetails != null) {
      final csrftoken = authdetails["csrftoken"],
          sessionid = authdetails["sessionid"];
      await _dio!.post(
        "/favouritepost/$postid",
        data: {"favourite": favourite},
        options: Options(
          headers: {
            'Cookie': "csrftoken=$csrftoken; sessionid=$sessionid",
            'X-CSRFToken': csrftoken
          },
        ),
      );
    }
  }
}
