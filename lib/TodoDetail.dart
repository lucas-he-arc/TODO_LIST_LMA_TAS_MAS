import 'package:todo_list_lma_tas_mas/TodoDataModel.dart';
import 'package:flutter/material.dart';

class TodoDetail extends StatelessWidget {

  //String nomTodo = "";

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
        ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){

          String nomTodo = "";

          showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  title: Text("Ajouter une TODO"),
                  content: Form(child: Column(
                    children: [
                      TextFormField(
                        onChanged: (String value){
                          nomTodo = value;
                        },
                        decoration: InputDecoration(hintText: "Titre"),
                      ),
                    ],
                  ),),
                  actions: <Widget>[
                    TextButton(
                        onPressed: (){
                          //createTodos();
                          Navigator.of(context).pop();
                        },
                        child: Text("Ajouter"))
                  ],
                );
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.red,
        ),
      ),
    );
  }
}
