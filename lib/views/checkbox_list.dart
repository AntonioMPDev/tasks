import 'package:flutter/material.dart';
import 'package:todo_list/services/api_service.dart';
import 'package:todo_list/views/todo_list.dart';

class CheckboxList extends StatefulWidget {
  final isDoneFromList;
  final id;
  final task;

  CheckboxList({this.isDoneFromList, this.id, this.task});

  @override
  _CheckboxListState createState() => _CheckboxListState();
}

class _CheckboxListState extends State<CheckboxList> {
  bool checkBoxFlag = true;
  bool? newCheckValue;
  bool? finalValue = false;

  @override
  Widget build(BuildContext context) {
    return  Checkbox(
      value: checkBoxFlag ? widget.isDoneFromList : newCheckValue,
      onChanged: (value){
        if(checkBoxFlag){
          setState(() {
            newCheckValue = value;
            checkBoxFlag = false;
            finalValue = value;
          });
        } else {
          setState(() {
            newCheckValue = !newCheckValue!;
            finalValue = value;
          });
        }
        print(finalValue);
        ApiService().updateTodo(widget.id,widget.task , finalValue).whenComplete(() =>  Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => TodoList())));
      },
    );
  }
}
