import 'package:dio/dio.dart';

class FeedService {
  final Dio _dio = Dio();
  final String BASE_URL = "http://10.0.2.2:8000/feeds";

  Future<bool> addPost({
    String? text,
    String? imageurl,
    required String csrftoken,
    required String sessionid,
  }) async {
    try {
      final response = await _dio.post("$BASE_URL/addpost/",
          data: {"text": text, "imageurl": imageurl},
          options: Options(headers: {'Cookie': "csrftoken=$csrftoken; sessionid=$sessionid",'X-CSRFToken': csrftoken}));
      if (response.data != null) {
        return true;
      }
    } catch (e) {
      print("Error, $e");
    }
    return false;
  }
}
