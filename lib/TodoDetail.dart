import 'package:flutter/material.dart';
import 'package:todo_list_lma_tas_mas/TodoDataModel.dart';

class TodoDetail extends StatelessWidget {

  final TodoDataModel todoDataModel;
  //const TodoDetail({Key? key, required this.todoDataModel}) : super(key: key);
  const TodoDetail({Key? key, required this.todoDataModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(todoDataModel.name),),
        body: Column(
          children: [
            Text(todoDataModel.name),
            Text(todoDataModel.desc)
          ],
        )
    );
  }

/*
  final TodoDataModel todoDataModel;
  //const TodoDetail({Key? key, required this.todoDataModel}) : super(key: key);
  const TodoDetail({Key? key, required this.todoDataModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(todoDataModel.name),),
      body: Column(
        children: [
          /*Checkbox(
              value: todoDataModel.valueCheckBox,
              onChanged: (value) => todoDataModel.valueCheckBox = true
          )*/
          Text(todoDataModel.name),
          Text(todoDataModel.desc)
        ],
      )
    );
  }*/
}
