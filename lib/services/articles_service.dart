import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/articles_models.dart';

class ArticlesService {
  Dio? _dio;

  ArticlesService() {
    BaseOptions options = BaseOptions(
      baseUrl: "${dotenv.env['BASE_URL']}/articles",
      connectTimeout: const Duration(seconds: 5),
    );
    _dio ??= Dio(options);
  }

  Future<List<ArticlesModel>?> getArticles() async {
    final response = await _dio!.get("/getallarticles");
    if (response.statusCode != null && response.statusCode! < 300) {
      return articlesModelFromJson(json.encode(response.data));
    }
    return null;
  }
}
