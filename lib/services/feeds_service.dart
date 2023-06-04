import 'dart:io';

import 'package:dio/dio.dart';
import 'package:student_hub/models/feeds_timeline_model.dart';

import '../database/account_db_helper.dart';

class FeedService {
  final Dio _dio = Dio();
  final String BASE_URL = "http://10.0.2.2:8000/feeds";

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

      final response = await _dio.post("$BASE_URL/addpost/",
          data: formData,
          options: Options(headers: {
            'Cookie': "csrftoken=$csrftoken; sessionid=$sessionid",
            'X-CSRFToken': csrftoken
          }));
      if (response.data != null) {
        return true;
      }
    } catch (e) {
      print("Error, $e");
    }
    return false;
  }

  Future<List<FeedsTimeline>> getMyTimeline() async {
    final authdetails = await AccountDbHelper.getCurrentUserCred();
    List<FeedsTimeline> result = [];
    if (authdetails != null) {
      final csrftoken = authdetails["csrftoken"],
          sessionid = authdetails["sessionid"];
      final response = await _dio.get(
        "$BASE_URL/timelineposts",
        options: Options(
          headers: {
            'Cookie': "csrftoken=$csrftoken; sessionid=$sessionid",
            'X-CSRFToken': csrftoken
          },
        ),
      );
      for (var post in response.data) {
        result.add(
          FeedsTimeline(
            id: post['id'],
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
    return result;
  }

  Future<void> favouritePost({required int postid, required bool favourite}) async {
    final authdetails = await AccountDbHelper.getCurrentUserCred();
    if (authdetails != null) {
      final csrftoken = authdetails["csrftoken"],
          sessionid = authdetails["sessionid"];
      await _dio.post(
        "$BASE_URL/favouritepost/$postid",
        data: {
          "favourite": favourite
        },
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
