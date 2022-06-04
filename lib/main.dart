//import 'dart:html';

import 'dart:ffi';
import 'package:file_picker/file_picker.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:async';                                          //Import LMA - Firebase
import 'package:cloud_firestore/cloud_firestore.dart';        //Import LMA - Firebase
import 'package:firebase_core/firebase_core.dart';            //Import LMA - Firebase
import 'package:flutter/material.dart';                       //Import LMA - Firebase
import 'package:provider/provider.dart';                      //Import LMA - Firebase
import 'package:todo_list_lma_tas_mas/PushNotification.dart';
import 'package:todo_list_lma_tas_mas/storage_service.dart';
import 'package:todo_list_lma_tas_mas/utilities.dart';
import 'package:todo_list_lma_tas_mas/TodoDetail.dart';
import 'firebase_options.dart';                               //Import LMA - Firebase
import 'package:todo_list_lma_tas_mas/TodoDataModel.dart';
import 'package:todo_list_lma_tas_mas/TodoWidget.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

/*
* Author(s) : Lucas Martinez, Téo Assunçao, Marc-Antoine Sudan
*/


void main() async {
/*
* Author(s) : Lucas
*/
  WidgetsFlutterBinding.ensureInitialized();
  //intialisation Firebase
  await Firebase.initializeApp(
      options: FirebaseOptions(
      apiKey: "AIzaSyBU0ITv2-yYH-qLXcT7rZXSs6fazPGP4uU",
      appId: "1:535380240245:android:fc025dbf147f83d372d53c",
      messagingSenderId: "535380240245",
      projectId: "flutter-todolist-1683a",
      storageBucket: "gs://flutter-todolist-1683a.appspot.com"
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

  TextEditingController _searchController = TextEditingController();
  ScrollController _actualiserListe = ScrollController();
  List todos = [];
  final db = FirebaseFirestore.instance.collection("MesTodos");
  List _allResults = [];
  List _todoAAffiches = [];
  Map<String, List<String>> _allResultsTag = new Map();

  @override
  void initState() {
    super.initState();
/*
* Author(s) : Lucas
*/
    AwesomeNotifications().createdStream.listen((notification) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Notification Created on ${notification.channelKey}',
        ),
      ));
    });

    _searchController.addListener(_onSearchChanged);
    _actualiserListe.addListener(_onSearchChanged);
  }
/*
* Author(s) : Téo Assunçao
*/
  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
/*
* Author(s) : Téo Assunçao
*/
  _onSearchChanged() {
    searchResultList();
  }
/*
* Author(s) : Téo Assunçao
*/
  searchResultList() {
    _todoAAffiches.clear();
    setState(() {
      if (_searchController.text.toLowerCase() != "") {
        for (String uneTodo in _allResults) {
          if (uneTodo.toLowerCase().contains(_searchController.text.toLowerCase())) {
            _todoAAffiches.add(uneTodo);
            //print(_todoAAffiches);
          }
        }

        _allResultsTag.forEach((key, value) {
          for(String everyTag in value){

            if(everyTag.toLowerCase().contains(_searchController.text.toLowerCase())) {
              _todoAAffiches.add(key);
            }
          }
        });
      }else{
        _todoAAffiches.addAll(_allResults);
      }
    });

  }
/*
* Author(s) : Lucas Martinez
*/
  deleteTodos(String toDoToDelete) {
    db.doc(toDoToDelete).delete();
  }
/*
* Author(s) : Téo Assunçao, Lucas Martinez, Marc-Antoine Sudan
*/
  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    return Scaffold(
        resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Mes TODOs")
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          TodoWidget().buildSimpleTodo(context),
          TodoWidget().buildImageTodo(context),
          TodoWidget().buildCheckboxTodo(context),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Text("Rechercher une TODO"),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
              )
            ),
            Expanded(
                child: StreamBuilder(
                    stream: db.snapshots(),
                    builder: (context, AsyncSnapshot snapshots){
                      _allResults.clear();
                      if(snapshots.hasData){
                        return ListView.builder(
                            itemCount : snapshots.data?.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot documentSnapshot = snapshots.data.docs[index];

                              var show = false;

                              _allResults.add(documentSnapshot["TodoTitle"]);

                              List<String> tagList = [];

                              for(String tag in documentSnapshot["tags"]){
                                tagList.add(tag);
                              }

                              _allResultsTag.putIfAbsent(documentSnapshot["TodoTitle"], () => tagList);
                              tagList = [];

                              String id = documentSnapshot.reference.id;

                List<TodoDataModel> todoData = List.generate(snapshots.data?.docs.length, (index) =>
                    TodoDataModel(id,documentSnapshot["TodoTitle"],documentSnapshot["TododescTodo"], documentSnapshot["TodoImage"], documentSnapshot["TodoColor"],documentSnapshot["TodoDate"] ,documentSnapshot["TodoCheckbox"], documentSnapshot["tags"]));

                String couleurString = documentSnapshot["TodoColor"];//"0xFF" +

                if( _searchController.text == ""){
                  show = true;
                }else{
                  show = false;
                }

                  if(_todoAAffiches.contains(documentSnapshot["TodoTitle"].toLowerCase()) || show){
                    return SizedBox (
                        width: 50,
                        child :Card(
                            color: Color(int.parse(couleurString)),
                            child:InkWell(
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (Context)=>TodoDetail(todoDataModel: todoData[index],couleurChoisie: documentSnapshot["TodoColor"])));
                                },
                                child: Column(
                                    children: <Widget>[
                                      FutureBuilder(
                                          future: storage.getImageURL(documentSnapshot["TodoImage"]),
                                          builder: (BuildContext context, AsyncSnapshot<String> snapshot){

                                              if(snapshot.data != "" && snapshot.data != null){

                                              return Container(
                                                width: 500,
                                                height: 200,
                                                child:
                                                Image.network(
                                                  //snapshot.data!,
                                                  snapshot.data!,
                                                  fit: BoxFit.contain,
                                                ),
                                              );
                                            }else{
                                              return SizedBox.shrink();
                                            }
                                          }
                                      ),
                                      ListTile(
                                        title: Text(documentSnapshot["TodoTitle"]),
                                        subtitle: Text(formatDate(documentSnapshot["TodoDate"].toDate(), [dd, " ", MM, " ", yyyy, " " , hh, ":", nn]).toString()),
                                        trailing: IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                            ),
                                            onPressed: (){
                                              setState(() {
                                                deleteTodos(id);
                                              });
                                            }
                                        ),
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0),
                                          child: Wrap(
                                            children: [
                                              for (var tag in documentSnapshot["tags"]) Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.teal,
                                                      borderRadius: BorderRadius.circular(100.0)),
                                                  padding: const EdgeInsets.only(left: 8.0,right: 8.0, top: 5.0, bottom: 5.0),
                                                  margin: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
                                                  child: Wrap (alignment: WrapAlignment.start, children:[
                                                    const Icon(
                                                      Icons.local_offer_outlined,
                                                      color: Colors.amberAccent,
                                                      size: 20.0,
                                                    ),
                                                    Text(" " + tag, style: const TextStyle(fontSize: 15.0, color: Colors.white))
                                                  ],)
                                              )
                                            ],
                                          )
                                      ),
                                    ]
                                )
                            )
                        )
                    );
                  }else{
                    return SizedBox.shrink();
                  }
                            });

                      }else{
                        return Text(
                          'No Data...',
                        );
                      }

                    }

                ),
            )
          ],
        ),
      )
    );
  }
}

