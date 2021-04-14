import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:google_login/models/new.dart';
import 'package:google_login/utils/news_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final newsRepository = NewsRepository();
  SearchBloc() : super(SearchInitial());

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    // Mostrar las noticias de deportes
    if (event is RequestApiNewsEvent) {
      yield LoadApiNewsState();
      yield LoadedApiNewsState(
          noticiasExternasList:
              await newsRepository.getAvailableNoticias('sports'));
    }
    // Noticias con query
    else if (event is RequestQueryNewsEvent) {
      // yield LoadApiNewsState();
      yield LoadedApiNewsState(
          noticiasExternasList:
              await newsRepository.getAvailableNoticias(event.query));
    }
  }
}
