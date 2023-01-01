import 'dart:async';
import 'dart:convert';
import 'package:api_app_using_bloc/constants/strings.dart';
import 'package:http/http.dart' as http;
import 'package:api_app_using_bloc/models/news_model.dart';

enum NewsAction { fetch, delete }

class NewsBloc {
  final _stateStreamController = StreamController<List<Articles>>();
  StreamSink<List<Articles>?> get _newsSink => _stateStreamController.sink;
  Stream<List<Articles>> get newsStream => _stateStreamController.stream;

  final _evenStreamController = StreamController<NewsAction>();
  StreamSink<NewsAction> get eventSink => _evenStreamController.sink;
  Stream<NewsAction> get _evenStream => _evenStreamController.stream;

  NewsBloc() {
    _evenStream.listen((event) async {
      if (event == NewsAction.fetch) {
        try {
          var news = await getNews();
          _newsSink.add(news.articles);
        } on Exception {
          _newsSink.addError("Something Went Wrong");
        }
      }
    });
  }

  Future getNews() async {
    var client = http.Client();
    var newsModel;

    try {
      var url = Uri.parse(Strings.news_url_path);
      var response = await client.get(url);
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);

        newsModel = NewsModel.fromJson(jsonMap);
      }
    } on Exception {
      return "Error";
    }
    return newsModel;
  }
}
