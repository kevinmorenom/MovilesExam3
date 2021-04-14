part of 'upload_bloc.dart';

abstract class UploadEvent extends Equatable {
  const UploadEvent();

  @override
  List<Object> get props => [];
}

class InitialEvent extends UploadEvent {}

//boton dee imagen
class PickImageEvent extends UploadEvent {}

//boton de guardar
class SaveNewElementEvent extends UploadEvent {
  final New noticia;

  SaveNewElementEvent({@required this.noticia});

  @override
  List<Object> get props => [noticia];
}

class SaveApiNewsEvent extends UploadEvent {
  final New noticia;

  SaveApiNewsEvent({@required this.noticia});

  @override
  List<Object> get props => [noticia];
}
