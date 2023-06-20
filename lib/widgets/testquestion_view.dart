// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/test_questions_models.dart';
import '../providers/test_screen_providers.dart';

class TestQuestionView extends StatefulWidget {
  const TestQuestionView(
      {super.key, required this.questiondata, required this.questionindex});
  final Question questiondata;
  final int questionindex;
  @override
  State<TestQuestionView> createState() => _TestQuestionViewState();
}

class _TestQuestionViewState extends State<TestQuestionView> {
  int selected = -1;
  List<String> options = ['A', 'B', 'C', 'D'];

  getOption({required int index}) {
    switch (index) {
      case 0:
        return widget.questiondata.optionA;
      case 1:
        return widget.questiondata.optionB;
      case 2:
        return widget.questiondata.optionC;
      case 3:
        return widget.questiondata.optionD;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.questiondata.question,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        for (int i = 0; i < 4; i++)
          Consumer(builder: (context, ref, child) {
            final currentSelection = ref.watch(questionChoicesNotifierProvider);

            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: GestureDetector(
                onTap: () {
                  var previousdata = ref.read(
                      questionChoicesNotifierProvider)[widget.questionindex];
                  debugPrint(previousdata);
                  var updatedData = previousdata == options[i] ? -1 : i;
                  ref.read(questionChoicesNotifierProvider.notifier).update(
                      widget.questionindex,
                      updatedData == -1 ? "-1" : options[updatedData]);
                  // setState(() {
                  //   selected = updatedData;
                  // });
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.black,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor:
                                  currentSelection[widget.questionindex] ==
                                          options[i]
                                      ? Colors.amber
                                      : Colors.white,
                            ),
                          ),
                        ),
                        Expanded(child: Text(getOption(index: i))),
                      ],
                    ),
                  ),
                ),
              ),
            );
          })
      ],
    );
  }
}
