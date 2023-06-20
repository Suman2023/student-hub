import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_hub/providers/test_screen_providers.dart';
import 'package:student_hub/screens/testview_screen.dart';

class TestScreen extends ConsumerWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTests = ref.watch(fetchAllTestsProvider);
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              const SliverAppBar(
                title: Text("Test"),
                elevation: 0.0,
                automaticallyImplyLeading: false,
                // expandedHeight: 0,
                floating: true,
                snap: true,
                backgroundColor: Colors.white,
              )
            ];
          },
          body: allTests.when(
              data: (data) => ListView.builder(
                    itemCount: data.length,
                    addAutomaticKeepAlives: false,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        ref
                            .read(questionChoicesNotifierProvider.notifier)
                            .init(length: data[index].questionCount);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => TestViewScreen(
                              testName: data[index].testname,
                              testid: data[index].id,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(data[index].testname,
                                          maxLines: 3,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                          )),
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                      size: 36,
                                    ),
                                  ],
                                ),
                                Text(
                                    "No. of questions: ${data[index].questionCount}")
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              error: (obj, stk) => Center(
                    child: Text("Something went wrong: $obj $stk"),
                  ),
              loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ))),
    );
  }
}
