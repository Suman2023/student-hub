import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/feed_post.dart';

class FeedsScreen extends ConsumerWidget {
  const FeedsScreen({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        backgroundColor: Colors.blue[300],
        onPressed: () {},
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
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 1));
          },
          child: ListView.builder(
            itemCount: 100,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: FeedPostWidget(
                  width: size.width,
                  text: "Hello this is a pic",
                  imgurl:
                      "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fc.pxhere.com%2Fphotos%2F23%2Fe9%2Fpeople_portrait_child_poverty_male_black_and_white_looking_eyes-543713.jpg!d&f=1&nofb=1&ipt=44c4e0a5b76abf57b5d0f9b37a2c85669d26b1fdff5ccafddb5d9f1cbd11d7e4&ipo=images",
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
