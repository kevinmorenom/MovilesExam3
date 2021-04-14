part of 'my_news_bloc.dart';

abstract class MyNewsState extends Equatable {
  const MyNewsState();

  @override
  List<Object> get props => [];
}

class MyNewsInitial extends MyNewsState {}

//circular progress indicator
class LoadingState extends MyNewsState {}

//indicador de que se guardo bien
class SavedNewState extends MyNewsState {}

class EmptyNewsState extends MyNewsState {}

//mostrar errores
class ErrorMessageState extends MyNewsState {
  final String errorMsg;

  ErrorMessageState({@required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}

//cuando se trae la vista la imagen seleccionada
class PickedImageState extends MyNewsState {
  final File image;

  PickedImageState({@required this.image});

  @override
  List<Object> get props => [image];
}

//cuando se trae las noticias de Firebase
class LoadedNewsState extends MyNewsState {
  final List<New> noticiasList;

  LoadedNewsState({@required this.noticiasList});

  @override
  List<Object> get props => [noticiasList];
}
