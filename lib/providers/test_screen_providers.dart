import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestQuestionNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    return [];
  }

  void init(int length) {
    state = List.generate(10, (index) => "-1");
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
