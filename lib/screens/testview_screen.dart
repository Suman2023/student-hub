import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_hub/widgets/testquestion_view.dart';

import '../providers/test_screen_providers.dart';

class TestViewScreen extends ConsumerStatefulWidget {
  const TestViewScreen(
      {super.key, required this.testName, required this.testid});
  final String testName;
  final int testid;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TestViewScreenState();
}

class _TestViewScreenState extends ConsumerState<TestViewScreen> {
  @override
  Widget build(BuildContext context) {
    final testQuestions = ref.watch(fetchAllQuestionsProvider(widget.testid));
    final submissionLoading = ref.watch(testSubmissionLoadingProvider);
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
            onPressed: submissionLoading
                ? null
                : () async {
                    ref.read(testSubmissionLoadingProvider.notifier).state =
                        true;
                    final answerList =
                        ref.read(questionChoicesNotifierProvider);
                    debugPrint("Submit Test with answers: $answerList");
                    bool success = await ref
                        .read(testServiceProvider)
                        .submitTest(ansList: answerList, testid: widget.testid);
                    if (mounted && success) {
                      ref.read(testSubmissionLoadingProvider.notifier).state =
                          false;
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Test Submitted successfully!")));
                    } else {
                      ref.read(testSubmissionLoadingProvider.notifier).state =
                          false;
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Failed to Submit. Try again")));
                    }
                  },
            child: submissionLoading
                ? const CircularProgressIndicator()
                : const Text("Submit"),
          )
        ],
      ),
      body: testQuestions.when(
        data: (data) {
          return data == null
              ? const Center(
                  child: Text("No Question found."),
                )
              : ListView.builder(
                  itemCount: data.questions.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TestQuestionView(
                      questionindex: index,
                      questiondata: data.questions[index],
                    ),
                  ),
                );
        },
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
