// ignore_for_file: prefer_const_constructors, unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_hub/providers/feed_screen_providers.dart';
import 'package:student_hub/screens/add_post_screen.dart';

import '../widgets/feed_post.dart';

class FeedsScreen extends ConsumerStatefulWidget {
  const FeedsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends ConsumerState<FeedsScreen> {
  // ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final timelinefeeds = ref.watch(timelineFeedsProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        backgroundColor: Colors.blue[300],
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddPostScreen()));
        },
        child: const FaIcon(FontAwesomeIcons.penNib),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            const SliverAppBar(
              title: Text("Timeline"),
              elevation: 0.0,
              automaticallyImplyLeading: false,
              // expandedHeight: 0,
              floating: true,
              snap: true,
              backgroundColor: Colors.white,
            )
          ];
        },
        // list of images for scrolling
        body: RefreshIndicator(
            onRefresh: () async {
              ref.refresh(timelineFeedsProvider.future);
              setState(() {});
            },
            child: timelinefeeds.when(
                data: (data) {
                  // debugPrint(data[0].likedByme.toString());
                  return data.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("No Post Found please Refresh"),
                              IconButton(
                                  onPressed: () =>
                                      ref.refresh(timelineFeedsProvider.future),
                                  icon: const Icon(Icons.refresh))
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: FeedPostWidget(
                                key: Key(data[index].id.toString()),
                                width: size.width,
                                data: data[index],
                              ),
                            );
                          },
                        );
                },
                error: (stk, obj) => const Text(""),
                loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ))),
      ),
    );
  }
}
