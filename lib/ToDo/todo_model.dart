import 'package:hive/hive.dart';


part 'todo_model.g.dart';

@HiveType(typeId: 1)
class ToDo{
  @HiveField(0)
  late final String title;

  @HiveField(1)
  final bool isCompleted;
  ToDo({
    required this.title,
    required this.isCompleted,
    });
}