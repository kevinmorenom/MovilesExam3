part of 'my_news_bloc.dart';

abstract class MyNewsEvent extends Equatable {
  const MyNewsEvent();

  @override
  List<Object> get props => [];
}

//Sera activado al iniciar
class RequestAllNewsEvent extends MyNewsEvent {}

//boton dee imagen
class PickImageEvent extends MyNewsEvent {}

//boton de guardar
class SaveNewElementEvent extends MyNewsEvent {
  final New noticia;

  SaveNewElementEvent({@required this.noticia});

  @override
  List<Object> get props => [noticia];
}
