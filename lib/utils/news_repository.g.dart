// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_repository.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NewsAdapter extends TypeAdapter<NewsRepository> {
  @override
  final int typeId = 1;

  @override
  NewsRepository read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NewsRepository().._noticiasList = (fields[0] as List)?.cast<New>();
  }

  @override
  void write(BinaryWriter writer, NewsRepository obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj._noticiasList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
