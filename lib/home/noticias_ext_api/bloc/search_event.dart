part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class RequestApiNewsEvent extends SearchEvent {
  @override
  List<Object> get props => [];
}

class RequestQueryNewsEvent extends SearchEvent {
  final String query;

  RequestQueryNewsEvent({@required this.query});

  @override
  List<Object> get props => [query];
}
