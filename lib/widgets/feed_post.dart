import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FeedPostWidget extends StatefulWidget {
  const FeedPostWidget({
    Key? key,
    required this.text,
    required this.width,
    this.imgurl,
  }) : super(key: key);
  final String text;
  final String? imgurl;
  final double width;

  @override
  State<FeedPostWidget> createState() => _FeedPostWidgetState();
}

class _FeedPostWidgetState extends State<FeedPostWidget> {
  bool hearted = false;

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
                  Text(
                    widget.text,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  widget.imgurl == null
                      ? Container()
                      : SizedBox(
                          width: widget.width - 68,
                          child: Image.network(
                            widget.imgurl!,
                            fit: BoxFit.fill,
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                      width: widget.width - 76,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                hearted = !hearted;
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
                          ),
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
