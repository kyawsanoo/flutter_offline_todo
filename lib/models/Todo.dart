import 'package:hive/hive.dart';

part 'Todo.g.dart';

@HiveType(typeId: 1)
class Todo {
  Todo({this.id, this.title, this.completed});

  @HiveField(0)
  int? id;

  @HiveField(1)
  String? title;

  @HiveField(2)
  bool? completed;
}