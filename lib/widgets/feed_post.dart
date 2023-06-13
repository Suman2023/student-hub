import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_hub/models/feeds_timeline_model.dart';
import 'package:student_hub/providers/feed_screen_providers.dart';

class FeedPostWidget extends StatefulWidget {
  const FeedPostWidget({Key? key, required this.width, required this.data})
      : super(key: key);
  final FeedsTimeline data;
  final double width;

  @override
  State<FeedPostWidget> createState() => _FeedPostWidgetState();
}

class _FeedPostWidgetState extends State<FeedPostWidget> {
  bool hearted = false;
  int totalLikes = 0;

  @override
  void initState() {
    print(widget.data.totalLike);
    hearted = widget.data.likedByme == 1 ? true : false;
    totalLikes = widget.data.totalLike;
    super.initState();
  }

  void heartPost(WidgetRef ref) async {
    if (hearted) {
      totalLikes -= 1;
    } else {
      totalLikes += 1;
    }
    hearted = !hearted;
    setState(() {});
    await ref
        .read(feedServiceProvider)
        .favouritePost(postid: widget.data.id, favourite: hearted);
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
                  Text(
                    "${widget.data.firstName} ${widget.data.lastName}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "@${widget.data.username}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: widget.width - 68,
                    child: Text(
                      widget.data.text,
                      maxLines: 100,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  widget.data.imageurl.isEmpty
                      ? Container()
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          width: widget.width - 68,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              imageUrl: widget.data.imageurl,
                              placeholder: (context, str) => AspectRatio(
                                aspectRatio: widget.data.aspectratio,
                                child: Container(
                                  color: Colors.blueGrey[100],
                                ),
                              ),
                              errorWidget: (context, url, error) => AspectRatio(
                                aspectRatio: widget.data.aspectratio,
                                child: const Center(
                                  child: Text("Something went Wrong"),
                                ),
                              ),
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
                                onTap: () async {
                                  heartPost(ref);
                                  ref.refresh(timelineFeedsProvider.future);
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    hearted
                                        ? const FaIcon(
                                            FontAwesomeIcons.solidHeart,
                                            color: Colors.red,
                                          )
                                        : const FaIcon(
                                            FontAwesomeIcons.heart,
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(totalLikes > 0
                                          ? totalLikes.toString()
                                          : ""),
                                    )
                                  ],
                                ));
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
