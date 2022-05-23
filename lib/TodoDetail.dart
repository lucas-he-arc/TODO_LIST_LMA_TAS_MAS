//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list_lma_tas_mas/TodoDataModel.dart';
import 'package:flutter/material.dart';

class TodoDetail extends StatelessWidget {
  //String taskName = "";
  final TodoDataModel todoDataModel;

  const TodoDetail({Key? key, required this.todoDataModel}) : super(key: key);

  //map firebase
  //Map<String,bool> tasks = {"TaskTitle" : taskName, "TododescTodo" : descTodo};


  updateTodo(String newDescription){
    FirebaseFirestore.instance.collection("MesTodos").doc(todoDataModel.id).update({"TododescTodo" : newDescription});
    print(newDescription);
  }

  addTask(String taskName){
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection("MesTodos").doc(todoDataModel.name);

    this.todoDataModel.values.putIfAbsent(taskName, () => false);

    documentReference.set({"listeTaches": {taskName : false}}, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    var docRef = FirebaseFirestore.instance
        .collection('MesTodos').doc(todoDataModel.id);

    docRef.get().then((value) => print(value.data()));
    /*docRef.snapshots(includeMetadataChanges: true).listen((event) {
      print(event.);
    });*/
    String newDescription = todoDataModel.desc;
    //TODO - Parcourir les items de la firebase
    return Scaffold(
        appBar: AppBar(title: Text(todoDataModel.name),),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('MesTodos').doc(todoDataModel.id).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return new Text("Loading");
            }
            return new TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                decoration: InputDecoration(hintText : "Note"),
                initialValue: todoDataModel.desc,
                onChanged: (String value){
                  newDescription = value;
                },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          focusColor: Colors.green,
          onPressed: () => updateTodo(newDescription),
          child: Icon(Icons.save)

      ),
    );

    //-------------
    floatingActionButton:
    FloatingActionButton(
      onPressed: () {
        String taskName = "";

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Ajouter une TODO"),
                content: Form(child: Column(
                  children: [
                    TextFormField(
                      onChanged: (String value) {
                        taskName = value;
                      },
                      decoration: InputDecoration(hintText: "Titre"),
                    ),
                  ],
                ),),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        //createTodos();
                        //todoDataModel.values.putIfAbsent(taskName, () => false);
                        addTask(taskName);
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
    )
    ;
  }

}
