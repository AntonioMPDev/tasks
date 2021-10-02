import 'package:todo_list/models/source_model.dart';

class Todo {
  int? id;
  String? task;
  bool? isDone;

  Todo({
    this.id,
    this.task,
    this.isDone
  });

  factory Todo.fromJson(Map<String, dynamic> json){
    return Todo(
      id : json['id'],
      task : json['task'],
      isDone : json['isDone'],
    );
  }
}