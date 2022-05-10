import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:async';                                          //Import LMA - Firebase
import 'package:cloud_firestore/cloud_firestore.dart';        //Import LMA - Firebase
import 'package:firebase_core/firebase_core.dart';            //Import LMA - Firebase
import 'package:flutter/material.dart';                       //Import LMA - Firebase
import 'package:provider/provider.dart';                      //Import LMA - Firebase
import 'firebase_options.dart';                               //Import LMA - Firebase


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



    final ref = FirebaseFirestore.instance.collection("MesTodos").snapshots().listen(
      (res) => print("Successfully completed"),
      onError: (e) => print("Error completing: $e"),
    );

    StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('MesTodos').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            return new ListTile(
              title: new Text(document['title']),
              subtitle: new Text(document['author']),
            );
          }).toList(),
        );
      },
    );

    /*
    Stream streamDoc = FirebaseFirestore.instance.collection("MesTodos").snapshots().listen(
          (res) => print("Successfully completed"),
      onError: (e) => print("Error completing: $e"),
    );*/

    //FirebaseFirestore.instance.collection("MesTodos").snapshots().listen(res);

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
                  content: TextField(
                    onChanged: (String value){
                      input = value;
                    },
                  ),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
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
          stream: FirebaseFirestore.instance.collection('MesTodos').snapshots()
          , builder: (context, AsyncSnapshot snapshots){
        if(snapshots.hasData){
          return ListView.builder(
              itemCount : snapshots.data?.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot documentSnapshot = snapshots.data.docs[index];
                return ListTile(
                        title: Text (documentSnapshot["TodoTitle"]),
                        trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color:Colors.red,
                            ),
                            onPressed: (){
                              setState(() {
                                todos.removeAt(index);
                              });
                            }
                        ),
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
