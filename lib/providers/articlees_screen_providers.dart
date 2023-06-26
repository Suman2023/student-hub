import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_hub/services/articles_service.dart';

import '../models/articles_models.dart';

final articlesProvider = Provider<ArticlesService>((ref) => ArticlesService());

final allArticlesProvider = FutureProvider<List<ArticlesModel>?>((ref) async {
  final articleService = ref.read(articlesProvider);
  return await articleService.getArticles();
});
