part of 'my_news_bloc.dart';

abstract class MyNewsEvent extends Equatable {
  const MyNewsEvent();

  @override
  List<Object> get props => [];
}

//Sera activado al iniciar
class RequestAllNewsEvent extends MyNewsEvent {}

class EmptyNewsEvent extends MyNewsEvent {}
