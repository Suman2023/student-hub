import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_hub/models/articles_models.dart';
import 'package:student_hub/widgets/articles_webview_widget.dart';

class ArticlesScreen extends ConsumerWidget {
  ArticlesScreen({super.key});

  final List<ArticlesModel> articles = List.generate(
    100,
    (index) => ArticlesModel(
      id: index,
      name: "Flutter: Using widget.Variable before the build method ",
      description:
          "you may need to get the variables from the stateful widget before Widget build(BuildContext context) runs. How to do so? The solution is to use the initState() method:",
      articleurl:
          "https://www.kindacode.com/article/flutter-using-widget-variable-before-the-build-method/",
      imageurl:
          "https://firebasestorage.googleapis.com/v0/b/student-hub-f1c4f.appspot.com/o/sumanmitra203%2FIMG_20230601_174100.jpg-2023-06-04T19:17:27.192269?alt=media&token=bfec405b-7242-4332-9d81-97105cbf503c",
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            const SliverAppBar(
              title: Text("Articles"),
              elevation: 0.0,
              automaticallyImplyLeading: false,
              // expandedHeight: 0,
              floating: true,
              snap: true,
              backgroundColor: Colors.white,
            )
          ];
        },
        body: ListView.builder(
          itemCount: articles.length,
          itemBuilder: ((context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ArticleWebview(
                          articleurl: articles[index].articleurl)));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: Colors.transparent,
                  child: Container(
                    height: size.height / 6,
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[100],
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(10),
                            ),
                          ),
                          width: size.width / 4,
                          child: ClipRRect(
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(10),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: articles[index].imageurl,
                                placeholder: (context, str) => AspectRatio(
                                  aspectRatio:
                                      (size.width / 4) / (size.height / 6),
                                  child: Container(
                                    color: Colors.blueGrey[100],
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    AspectRatio(
                                  aspectRatio:
                                      (size.width / 4) / (size.height / 6),
                                  child: const Center(
                                    child: Text("Something went Wrong"),
                                  ),
                                ),
                                fit: BoxFit.fill,
                              )
                              // Image.network(
                              //   articles[index].imageurl,
                              //   fit: BoxFit.fill,
                              // ),
                              ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 32.0),
                                    child: Text(
                                      articles[index].name * 1000,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    child: const Icon(
                                      Icons.bookmark_add,
                                      size: 36,
                                    ),
                                  )
                                ],
                              ),
                              Expanded(
                                child: Text(
                                  articles[index].description * 100,
                                  overflow: TextOverflow.fade,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
