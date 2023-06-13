import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/test_screen_providers.dart';

class TestQuestionView extends StatefulWidget {
  const TestQuestionView({super.key});

  @override
  State<TestQuestionView> createState() => _TestQuestionViewState();
}

class _TestQuestionViewState extends State<TestQuestionView> {
  int selected = -1;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Question",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        for (int i = 0; i < 4; i++)
          Consumer(builder: (context, ref, child) {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: GestureDetector(
                onTap: () {
                  ref
                      .read(questionChoicesNotifierProvider.notifier)
                      .update(1, i.toString());
                  setState(() {
                    selected = i;
                  });
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
                                  selected == i ? Colors.amber : Colors.white,
                            ),
                          ),
                        ),
                        const Text("This is an option"),
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
