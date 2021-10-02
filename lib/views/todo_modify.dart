import 'package:flutter/material.dart';
import 'package:todo_list/models/todo_model.dart';
import 'package:todo_list/services/api_service.dart';
import 'package:todo_list/views/todo_list.dart';

class TodoModify extends StatefulWidget {

  final todoId;
  final task;
  final isDone;
  TodoModify({this.todoId = '0',this.task='',this.isDone = false});

  @override
  _TodoModifyState createState() => _TodoModifyState();
}

class _TodoModifyState extends State<TodoModify> {

  bool get isEditing => widget.todoId != null;
  bool _isDone = false;
  String _task = '';
  int _id =  0;
  Future<Todo>? _futureTodo;
  bool _isdoneEditing = false;
  bool _flag = true;
  bool get toCheck => widget.isDone == "true" ? true : false;

  @override
  Widget build(BuildContext context) {
    if(isEditing){
      setState(() {
        var toCheck = widget.isDone == 'true' ? true : false;
      });
    }
    return Scaffold(
      appBar: AppBar(title: Text(!isEditing ? 'Create Task' : 'Editing Task')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextFormField(
              initialValue: isEditing ? widget.task : '',
              decoration: InputDecoration(
                hintText: isEditing ? widget.task : 'Todo Title',
              ),
              onChanged: (text){
                setState(() {
                  _task = text;
                });
              },
            ),
            Row(
              children: [
                Text('is Done ?'),
                Checkbox(
                    value: !isEditing ? _isDone : _flag ? toCheck : _isdoneEditing,
                    onChanged: (value){
                      if(!isEditing){
                        setState(() {
                          _isDone = !_isDone;
                        });
                      } else {
                        setState(() {
                          if(_flag){
                            _isdoneEditing = !toCheck;
                            _flag = false;
                          }else {
                            _isdoneEditing = !_isdoneEditing;
                          }
                        });
                      }
                    }
                ),
              ],
            ),
            Container(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (){
                  // Navigator.of(context).pop();
                  if(!isEditing){
                    setState(() {
                      _futureTodo = ApiService().createTodo(_task, _isDone).whenComplete(() =>  Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => TodoList())));
                    });
                  } else {
                    setState(() {
                      _futureTodo = ApiService().updateTodo(int.parse(widget.todoId),isEditing ?_task == '' ? widget.task : _task : _task ,!_flag? _isdoneEditing: toCheck).whenComplete(() =>  Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => TodoList())));
                    });
                  }
                },
                child: Text('Submit'),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
