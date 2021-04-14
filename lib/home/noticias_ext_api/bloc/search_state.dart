part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class LoadApiNewsState extends SearchState {}

class LoadedApiNewsState extends SearchState {
  final List<New> noticiasExternasList;
  LoadedApiNewsState({@required this.noticiasExternasList});
  @override
  List<Object> get props => [noticiasExternasList];
}

class FailedApiNewsState extends SearchState {
  final String fail;
  FailedApiNewsState({@required this.fail});
  @override
  List<Object> get props => [fail];
}
