import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:google_login/models/new.dart';
import 'package:google_login/utils/news_repository.dart';
import 'package:hive/hive.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final newsRepository = NewsRepository();
  Box _newsBox = Hive.box("Noticias");
  List<New> _hiveList = [];
  SearchBloc() : super(SearchInitial());

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    // Mostrar las noticias de deportes
    if (event is RequestApiNewsEvent) {
      List<New> noticias = await newsRepository.getAvailableNoticias('sports');
      yield LoadApiNewsState();
      if (noticias.length > 0) {
        await _newsBox.put("noticias", noticias);
        yield LoadedApiNewsState(noticiasExternasList: noticias);
      } else {
        _hiveList = List<New>.from(_newsBox.get("noticias", defaultValue: []));
        yield FailedApiNewsState(fail: "Sin conexión");
        yield LoadedApiNewsState(noticiasExternasList: _hiveList);
      }
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
