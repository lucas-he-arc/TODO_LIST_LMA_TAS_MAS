import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list_lma_tas_mas/TodoDataModel.dart';
import 'package:flutter/material.dart';

class TodoDetail extends StatelessWidget {

  //String taskName = "";
  final TodoDataModel todoDataModel;

  const TodoDetail({Key? key, required this.todoDataModel}) : super(key: key);

  //map firebase
  //Map<String,bool> tasks = {"TaskTitle" : taskName, "TododescTodo" : descTodo};



  addTask(String taskName){
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection("MesTodos").doc(todoDataModel.name);

    this.todoDataModel.values.putIfAbsent(taskName, () => false);

    documentReference.set({"listeTaches": {taskName : false}}, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    var docRef = FirebaseFirestore.instance
        .collection('MesTodos').doc(todoDataModel.name);

    docRef.get().then((value) => print(value.data()));
    /*docRef.snapshots(includeMetadataChanges: true).listen((event) {
      print(event.);
    });*/

    //TODO - Parcourir les items de la firebase
    return Scaffold(
        appBar: AppBar(title: Text(todoDataModel.name),),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('MesTodos').doc(todoDataModel.name).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return new Text("Loading");
            }
            //var userDocument = snapshot.data;
            return new Text("sd");
          },
        ));

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
