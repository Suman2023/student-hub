import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/test_models.dart';
import '../models/test_questions_models.dart';
import '../services/test_service.dart';

class TestQuestionNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    return [];
  }

  void init({int length = 10}) {
    state = List.generate(length, (index) => "-1");
  }

  void update(int index, String value) {
    List<String> newList = [];
    state.asMap().forEach((i, element) {
      if (i == index) {
        newList.add(value);
      } else {
        newList.add(element);
      }
    });
    state = newList;
  }
}

final questionChoicesNotifierProvider =
    NotifierProvider<TestQuestionNotifier, List<String>>(() {
  return TestQuestionNotifier();
});

final testServiceProvider = Provider<TestService>((ref) => TestService());

final fetchAllQuestionsProvider =
    FutureProvider<List<TestQuestionsModel>>((ref) async {
  final testService = ref.read(testServiceProvider);
  return testService.getAllQuestions(testid: 1);
});

final fetchAllTestsProvider = FutureProvider<List<TestModel>>((ref) async {
  final testService = ref.read(testServiceProvider);
  return testService.getAllTests();
});
