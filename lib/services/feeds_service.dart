import 'dart:io';

import 'package:dio/dio.dart';
import 'package:student_hub/models/feeds_timeline_model.dart';

import '../database/account_db_helper.dart';

class FeedService {
  Dio? _dio;

  FeedService() {
    BaseOptions options = BaseOptions(
      baseUrl:
          "https://20d3-2405-201-a80e-d829-1c5c-54af-bff8-76bb.ngrok-free.app/feeds",
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
      print("Error, $e");
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
      print("Something went wrong in getMyTimeline: $e");
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
