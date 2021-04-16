import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
part 'source.g.dart';

@HiveType(typeId: 3, adapterName: "SourceAdapter")
class Source extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;

  const Source({this.id, this.name});

  @override
  String toString() => 'Source(id: $id, name: $name)';

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  Source copyWith({
    String id,
    String name,
  }) {
    return Source(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  List<Object> get props => [id, name];
}
