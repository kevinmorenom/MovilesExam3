import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_login/models/new.dart';

part 'my_news_event.dart';
part 'my_news_state.dart';

class MyNewsBloc extends Bloc<MyNewsEvent, MyNewsState> {
  var _cFirestore = FirebaseFirestore.instance;
  MyNewsBloc() : super(MyNewsInitial());

  @override
  Stream<MyNewsState> mapEventToState(
    MyNewsEvent event,
  ) async* {
    if (event is RequestAllNewsEvent) {
      yield LoadingState();
      yield LoadingState();
      yield LoadedNewsState(noticiasList: await _getNoticias());
    }
  }

  Future<List<New>> _getNoticias() async {
    try {
      // var noticias = await _cFirestore.collection("noticias").get();
      var noticias = await _cFirestore.collection("noticias").get();
      return noticias.docs
          .map(
            (element) => New(
              source: null,
              author: element['author'],
              title: element['title'],
              description: element['description'],
              url: element['url'],
              urlToImage: element['urlToImage'],
              publishedAt: DateTime.parse(element["publishedAt"]),
              // content: element['content'],
              // //
            ),
          )
          .toList();
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
}
