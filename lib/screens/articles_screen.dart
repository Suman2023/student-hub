import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_hub/widgets/articles_webview_widget.dart';

import '../providers/articlees_screen_providers.dart';

class ArticlesScreen extends ConsumerWidget {
  const ArticlesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    final allArticles = ref.watch(allArticlesProvider);
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
        body: allArticles.when(
          data: ((data) {
            if (data == null) {
              return const Center(
                child: Text("No Articles Available"),
              );
            } else {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ArticleWebview(
                                articleurl: data[index].articleurl)));
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
                                height: size.height / 6,
                                child: ClipRRect(
                                    borderRadius: const BorderRadius.horizontal(
                                      left: Radius.circular(10),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: data[index].imageurl,
                                      placeholder: (context, str) =>
                                          AspectRatio(
                                        aspectRatio: (size.width / 4) /
                                            (size.height / 6),
                                        child: Container(
                                          color: Colors.blueGrey[100],
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          AspectRatio(
                                        aspectRatio: (size.width / 4) /
                                            (size.height / 6),
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
                                          padding: const EdgeInsets.only(
                                              right: 32.0),
                                          child: Text(
                                            data[index].title * 1000,
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
                                        data[index].description * 100,
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
              );
            }
          }),
          error: (obj, stk) =>
              const Center(child: Text("Something went wrong")),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
