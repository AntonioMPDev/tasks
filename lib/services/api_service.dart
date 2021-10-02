import 'dart:convert';

import 'package:http/http.dart';
import 'package:todo_list/models/todo_model.dart';

class ApiService{
    var url = Uri.https('testapi.growingupbusiness.com', '/api/todo_list');

    Future<List<Todo>> getTodo() async{
      Response res = await get(url);

      if(res.statusCode == 200){
        var json = jsonDecode(res.body);

        List<dynamic> body = json;

        List<Todo> todos = body.map((dynamic item) => Todo.fromJson(item)).toList();

        return todos;

      } else {
        throw('Cant get the item');
      }
    }

    Future<Todo> createTodo(String task, bool isDone) async{
      final response = await post(
        Uri.https('testapi.growingupbusiness.com', '/api/add_todo'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'task': task,
          'isDone': isDone
        }),
      );

      return Todo.fromJson(jsonDecode(response.body));
    }

    Future<Todo> deleteTodo(int? id) async{
      final response = await delete(
        Uri.https('testapi.growingupbusiness.com', '/api/todo/'+id.toString()),
      );

      return Todo.fromJson(jsonDecode(response.body));
    }

    Future<Todo> updateTodo(int? id, String task, bool? isDone) async{
      final response = await post(
        Uri.https('testapi.growingupbusiness.com', '/api/todo_update/'+id.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
          body: jsonEncode({
          'task': task,
          'isDone': isDone
        }),
      );
      print(isDone);
      print(task);

      return Todo.fromJson(jsonDecode(response.body));
    }

}