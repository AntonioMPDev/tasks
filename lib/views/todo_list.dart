import 'package:flutter/material.dart';
import 'package:todo_list/models/todo_model.dart';
import 'package:todo_list/services/api_service.dart';
import 'package:todo_list/views/checkbox_list.dart';
import 'package:todo_list/views/todo_delete.dart';
import 'package:todo_list/views/todo_modify.dart';


class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {

  ApiService client = ApiService();
  Future<Todo>? _futureTodo;
  bool checkBoxFlag = true;
  bool? newCheckValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo List')),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => TodoModify(todoId: null, task: null, isDone: null)));
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: client.getTodo(),
        builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot){
          List<Todo>? todos = snapshot.data;
          if(snapshot.hasData){
            return ListView.builder(
              padding: EdgeInsets.only(bottom: 100.0),
              itemCount: todos!.length,
              itemBuilder: (context, index) => Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xA4A2DEF1)))
                ),
                child: Dismissible(
                  key: ValueKey(todos[index].id),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction){
                    _futureTodo = ApiService().deleteTodo(todos[index].id);
                  },
                  confirmDismiss: (direction) async{
                    final result = await showDialog(
                        context: context,
                        builder: (_) => TodoDelete()
                    );
                    return result;
                  },
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.only(left: 16),
                    child: Align(child: Icon(Icons.delete, color: Colors.white), alignment: Alignment.centerLeft ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(color: todos[index].isDone.toString() == 'true' ? Colors.black12 : Colors.white),
                    child: ListTile(
                        leading: Text((index+1).toString()),
                        title: InkWell(
                          onTap: (){
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) => TodoModify(todoId: todos[index].id.toString(), task: todos[index].task.toString(), isDone:todos[index].isDone.toString())));
                          },
                          child: Text(todos[index].task.toString(), style: TextStyle(decoration: todos[index].isDone.toString() == 'true' ? TextDecoration.lineThrough : TextDecoration.none )),
                        ),
                        trailing: CheckboxList(isDoneFromList:todos[index].isDone,id: todos[index].id,task: todos[index].task)
                    ),
                  )
                )
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
