import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:async';                                          //Import LMA - Firebase
import 'package:cloud_firestore/cloud_firestore.dart';        //Import LMA - Firebase
import 'package:firebase_core/firebase_core.dart';            //Import LMA - Firebase
import 'package:flutter/material.dart';                       //Import LMA - Firebase
import 'package:provider/provider.dart';                      //Import LMA - Firebase
import 'firebase_options.dart';                               //Import LMA - Firebase
import 'package:todo_list_lma_tas_mas/CheckBoxState.dart';
import 'package:todo_list_lma_tas_mas/TodoDataModel.dart';
import 'package:todo_list_lma_tas_mas/TodoDetail.dart';


void main() async {
  //intialisation Firebase
  await Firebase.initializeApp(
      options: FirebaseOptions(
      apiKey: "AIzaSyBU0ITv2-yYH-qLXcT7rZXSs6fazPGP4uU",
      appId: "1:535380240245:android:fc025dbf147f83d372d53c",
      messagingSenderId: "535380240245",
      projectId: "flutter-todolist-1683a",
  ));
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(brightness: Brightness.dark, primaryColor: Colors.red),
    home: AppTODO(),
  ));
}

class AppTODO extends StatefulWidget {
  const AppTODO({Key? key}) : super(key: key);

  @override
  State<AppTODO> createState() => _AppTODOState();
}

class _AppTODOState extends State<AppTODO> {

  List todos = [];
  String nomTodo = "";
  String descTodo = "";
  final db = FirebaseFirestore.instance.collection("MesTodos");

  @override
  void initState() {
    super.initState();
    todos.add("item1");
    todos.add("item2");
  }

  createTodos(){
    DocumentReference documentReference =
    db.doc(nomTodo);

    //map
    Map<String,String> todos = {"TodoTitle" : nomTodo, "TododescTodo" : descTodo};

    documentReference.set(todos).whenComplete(() => print("$nomTodo created"));

    Map<String, Map<String, bool>> taskMap = Map<String, Map<String, bool>>();

    taskMap.putIfAbsent("listeTaches", () => Map<String, bool>());

    documentReference.update(taskMap);
  }

  deleteTodos(String toDoToDelete){
    db.doc(toDoToDelete).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes TODOs")
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
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
                      TextFormField(
                        onChanged: (String value){
                          descTodo = value;
                        },
                        decoration: InputDecoration(hintText: "Description"),
                      )
                    ],
                  ),),
                  actions: <Widget>[
                    TextButton(
                        onPressed: (){
                          createTodos();
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
      body: StreamBuilder(
          stream: db.snapshots()
          , builder: (context, AsyncSnapshot snapshots){
        if(snapshots.hasData){
          return ListView.builder(
              itemCount : snapshots.data?.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot documentSnapshot = snapshots.data.docs[index];

                List<TodoDataModel> todoData = List.generate(snapshots.data?.docs.length, (index) =>
                TodoDataModel(documentSnapshot["TodoTitle"],documentSnapshot["TododescTodo"]));

                return ListTile(
                    title: Text (documentSnapshot["TodoTitle"]),
                    trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color:Colors.red,
                        ),
                        onPressed: (){
                          setState(() {
                            //todos.removeAt(index);
                            //todo le remove avec la firebase
                          });
                        }
                    ),
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (Context)=>TodoDetail(todoDataModel: todoData[index])));
                    },
                  );
              });
        }else{
          return Text(
            'No Data...',
          );
        }

    }
    ),
      );
  }
}
