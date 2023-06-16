// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_hub/screens/base_screen.dart';
import 'package:student_hub/screens/test_screen.dart';
import 'package:student_hub/widgets/testquestion_view.dart';

import '../providers/test_screen_providers.dart';

class TestViewScreen extends ConsumerStatefulWidget {
  const TestViewScreen({super.key, required this.testName});
  final String testName;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TestViewScreenState();
}

class _TestViewScreenState extends ConsumerState<TestViewScreen> {
  @override
  Widget build(BuildContext context) {
    final testQuestions = ref.watch(fetchAllQuestionsProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(widget.testName),
        leading: IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        icon: const Icon(
                          Icons.warning,
                          color: Colors.red,
                        ),
                        title: const Text("Cancel the TEST?"),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Cancel")),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                    ..pop()
                                    ..pop();
                                },
                                child: const Text(
                                  "Confirm",
                                  style: TextStyle(color: Colors.red),
                                )),
                          ],
                        ),
                      ));
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          ElevatedButton(
            onPressed: () {
              final answerList = ref.read(questionChoicesNotifierProvider);
              debugPrint("Submit Test with answers: $answerList");
            },
            child: Text("Submit"),
          )
        ],
      ),
      body: testQuestions.when(
        data: (data) => ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.all(8.0),
            child: TestQuestionView(
              questionindex: index,
              questiondata: data[index],
            ),
          ),
        ),
        error: (obj, stk) => Center(
          child: Text("Something went wrong. Try Again $obj"),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
