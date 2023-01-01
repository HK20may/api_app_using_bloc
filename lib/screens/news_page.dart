import 'package:api_app_using_bloc/models/news_model.dart';
import 'package:api_app_using_bloc/services/news_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final newsBloc = NewsBloc();

  @override
  void initState() {
    newsBloc.eventSink.add(NewsAction.fetch);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
      ),
      body: StreamBuilder<List<Articles>>(
        stream: newsBloc.newsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var article = snapshot.data?[index];
                  var date = DateTime.parse(article?.publishedAt ?? " ");
                  var formattedTime = DateFormat('dd MMM - HH:mm').format(date);
                  return Container(
                    height: 100,
                    margin: const EdgeInsets.all(8),
                    child: Row(
                      children: <Widget>[
                        Card(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: AspectRatio(
                              aspectRatio: 1,
                              child: Image.network(
                                article?.urlToImage ?? "",
                                fit: BoxFit.cover,
                              )),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(formattedTime),
                              Text(
                                article!.title ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                article.description ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
