import 'dart:convert';

List<ArticlesModel> articlesModelFromJson(String str) =>
    List<ArticlesModel>.from(
        json.decode(str).map((x) => ArticlesModel.fromJson(x)));

class ArticlesModel {
  ArticlesModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageurl,
    required this.articleurl,
  });
  final int id;
  final String title, description, imageurl, articleurl;

  factory ArticlesModel.fromJson(Map<String, dynamic> json) => ArticlesModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        imageurl: json["image_url"],
        articleurl: json["source"],
      );
}
