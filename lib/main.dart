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
  String input = "";

  @override
  void initState() {
    super.initState();
    todos.add("item1");
    todos.add("item2");
  }

  createTodos(){
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection("MesTodos").doc(input);

    //map
    Map<String,String> todos = {"TodoTitle" : input};

    documentReference.set(todos).whenComplete(() => print("$input created"));
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
                  title: Text("Add"),
                  /*content: TextField(
                    onChanged: (String value){
                      input = value;
                    },
                  ),*/
                  content: TextField(
                    onChanged: (String value){
                      input = value;
                    },
                  ),
                  actions: <Widget>[
                    TextButton(
                        onPressed: (){
                          createTodos();
                          /*SetState((){
                            todoData.add(input);
                          });*/
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
      body: ListView.builder(
          itemCount : todoData.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                key: Key(todoName[index]),
                child: Card(
                  child: ListTile(
                    title: Text(todoName[index]),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color:Colors.red,
                      ),
                      onPressed: (){
                        setState(() {
                          todoData.removeAt(index);
                        });
                      }
                    ),
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (Context)=>TodoDetail(todoDataModel: todoData[index])));
                    },
                  ),
                ));
          }),
      );
  }
}
