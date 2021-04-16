import 'dart:convert';
import 'dart:io';

import 'package:google_login/models/new.dart';
import 'package:google_login/utils/secrets.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';

part 'news_repository.g.dart';

@HiveType(typeId: 1, adapterName: "NewsAdapter")
class NewsRepository {
  @HiveField(0)
  List<New> _noticiasList;

  // ignore: non_constant_identifier_names
  static final NewsRepository _NewsRepository = NewsRepository._internal();
  factory NewsRepository() {
    return _NewsRepository;
  }

  NewsRepository._internal();
  Future<List<New>> getAvailableNoticias(String query) async {
    // https://newsapi.org/v2/top-headlines?country=mx&q=futbol&category=sports&apiKey&apiKey=laAPIkey
    // crear modelos antes

    // final _uri = Uri(
    //   scheme: 'https',
    //   host: 'newsapi.org',
    //   path: 'v2/top-headlines',
    //   queryParameters: {"country": "mx", "apiKey": apiKey},
    // );
    var _uri;
    if (query == '') {
      _uri = Uri(
        scheme: 'https',
        host: 'newsapi.org',
        path: 'v2/top-headlines',
        queryParameters: {
          "country": "mx",
          "category": "sports",
          "apiKey": apiKey
        },
      );
    }

    //request a everything en caso de que el query no sea vacio
    else {
      _uri = Uri(
        scheme: 'https',
        host: 'newsapi.org',
        path: 'v2/everything',
        queryParameters: {"q": "$query", "apiKey": apiKey},
      );
    }

    try {
      final response = await get(_uri);
      if (response.statusCode == HttpStatus.ok) {
        List<dynamic> data = jsonDecode(response.body)["articles"];
        _noticiasList =
            ((data).map((element) => New.fromJson(element))).toList();
        return _noticiasList;
      }
      return [];
    } catch (e) {
      //arroje un error
      // throw "Ha ocurrido un error: $e";
      return [];
    }
  }
}
