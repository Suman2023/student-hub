import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_hub/widgets/testquestion_view.dart';

class TestViewScreen extends ConsumerStatefulWidget {
  const TestViewScreen({super.key, required this.testName});
  final String testName;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TestViewScreenState();
}

class _TestViewScreenState extends ConsumerState<TestViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.testName),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => const Padding(
          padding: EdgeInsets.all(8.0),
          child: TestQuestionView(),
        ),
      ),
    );
  }
}
