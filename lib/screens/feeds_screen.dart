import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_hub/providers/feed_screen_providers.dart';
import 'package:student_hub/screens/add_post_screen.dart';

import '../widgets/feed_post.dart';

class FeedsScreen extends ConsumerWidget {
  const FeedsScreen({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    final timelinefeeds = ref.watch(timelineFeedsProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        backgroundColor: Colors.blue[300],
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddPostScreen()));
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
              backgroundColor: Colors.red,
            )
          ];
        },
        // list of images for scrolling
        body: RefreshIndicator(
            onRefresh: () => ref.refresh(timelineFeedsProvider.future),
            child: timelinefeeds.when(
                data: (data) {
                  debugPrint(data[0].likedByme.toString());
                  return data.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("No Post Found please Refresh"),
                              IconButton(
                                  onPressed: () =>
                                      ref.refresh(timelineFeedsProvider.future),
                                  icon: Icon(Icons.refresh))
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
                                width: size.width,
                                id: data[index].id,
                                text: data[index].text,
                                imgurl: data[index].imageurl,
                                totalLike: data[index].totalLike,
                                likedByme: data[index].likedByme,
                              ),
                            );
                          },
                        );
                },
                error: (stk, obj) => Container(child: Text("")),
                loading: () => Center(
                      child: CircularProgressIndicator(),
                    ))),
      ),
    );
  }
}
