import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_hub/providers/feed_screen_providers.dart';

class FeedPostWidget extends StatefulWidget {
  const FeedPostWidget({
    Key? key,
    required this.id,
    required this.text,
    required this.width,
    this.imgurl,
    required this.totalLike,
    required this.likedByme,
  }) : super(key: key);
  final String text;
  final String? imgurl;
  final double width;
  final int id, likedByme, totalLike;

  @override
  State<FeedPostWidget> createState() => _FeedPostWidgetState();
}

class _FeedPostWidgetState extends State<FeedPostWidget> {
  bool hearted = false;

  @override
  void initState() {
    hearted = widget.likedByme == 1 ? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Name",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    "@username",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: widget.width - 68,
                    child: Text(
                      widget.text,
                      maxLines: 100,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  widget.imgurl == null || widget.imgurl!.isEmpty
                      ? Container()
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          width: widget.width - 68,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              widget.imgurl!,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                      width: widget.width - 76,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Consumer(builder: (context, ref, child) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  hearted = !hearted;
                                  ref.read(feedServiceProvider).favouritePost(
                                      postid: widget.id, favourite: hearted);
                                });
                              },
                              child: hearted
                                  ? const FaIcon(
                                      FontAwesomeIcons.solidHeart,
                                      color: Colors.red,
                                    )
                                  : const FaIcon(
                                      FontAwesomeIcons.heart,
                                    ),
                            );
                          }),
                          const FaIcon(
                            FontAwesomeIcons.comment,
                          ),
                          const FaIcon(
                            FontAwesomeIcons.share,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
