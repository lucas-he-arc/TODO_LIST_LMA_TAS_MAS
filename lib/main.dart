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
import 'package:todo_list_lma_tas_mas/storage_service.dart';
import 'firebase_options.dart';                               //Import LMA - Firebase
import 'package:todo_list_lma_tas_mas/TodoDataModel.dart';
import 'package:todo_list_lma_tas_mas/TodoDetail.dart';




void main() async {
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

  var storage = FirebaseFirestore.instance;
  List todos = [];
  String nomTodo = "";
  String descTodo = "";
  String fileName = "";
  String colorTodo = "0xFF0062ff";
  DateTime dateTodo = DateTime.now();
  TimeOfDay timeTodo = TimeOfDay.now();
  Map<String, bool> liste_checkbox = new Map();
  String listElement = "";
  var _controller = TextEditingController();
  final db = FirebaseFirestore.instance.collection("MesTodos");

  List _allResults = [];
  List _todoAAffiches = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _actualiserListe.addListener(_onSearchChanged);
    //_allResults = db.snapshots()
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    print(_searchController.text);
    print(_allResults);
    searchResultList();
    //print("saltu");
  }

  /*getTodosStreamSnapshot() async {

  }*/

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: dateTodo,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );

    if (selected != null) { // && selected != dateTodo
      dateTodo = selected;
      print(dateTodo);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null)
      timeTodo = picked;
    dateTodo = new DateTime(
        dateTodo.year, dateTodo.month, dateTodo.day, timeTodo.hour,
        timeTodo.minute);
  }

  void ajouterElementListe() {
    liste_checkbox.addEntries([MapEntry(listElement, false)]);
    _controller.clear();
    listElement = "";

    print("Ma map ---------------->" + liste_checkbox.keys.toString());
  }

  searchResultList() {
    _todoAAffiches.clear();
    if (_searchController.text != "") {
      for (String uneTodo in _allResults) {
        if (uneTodo.toLowerCase().contains(_searchController.text)) {
          _todoAAffiches.add(uneTodo);
          print(_todoAAffiches);
        }
      }

      //db.doc("toDoToDelete").delete();
      //Map<String,Object> todos = {"TodoTitle" : "xxxxxxxx", "TododescTodo" : "xxxxxxxx", "TodoDate" : "xxxxxxxx", "TodoImage" : "xxxxxxxx", "TodoColor" : "xxxxxxxx"};
      //db.add(todos);
      //db.doc("xxxxxxxx").delete();
    }
  }

  createTodos() {
    //map
    Map<String, Object> todos = {
      "TodoTitle": nomTodo,
      "TododescTodo": descTodo,
      "TodoDate": dateTodo,
      "TodoImage": fileName,
      "TodoColor": colorTodo,
      "TodoCheckbox": liste_checkbox
    };
    db.add(todos);
  }

  createTodosWithPicture() {
    Map<String, Object> todos = {
      "TodoTitle": nomTodo,
      "TododescTodo": descTodo,
      "TodoDate": dateTodo,
      "TodoImage": fileName,
      "TodoColor": colorTodo
    };
    db.add(todos);
    fileName = "";
  }

  deleteTodos(String toDoToDelete) {
    db.doc(toDoToDelete).delete();
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    return Scaffold(
      appBar: AppBar(
        //title: Text("Mes TODOs")
        title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Center(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          /* Clear the search field */
                        },
                      ),
                      hintText: 'Search...',
                      border: InputBorder.none),
                )
            )

        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
              child: Icon(Icons.add),
              label: ('Todo'),
              onTap: () =>
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Ajouter une TODO"),
                          content: Form(child: Column(
                            children: <Widget>[
                              TextFormField(
                                onChanged: (String value) {
                                  nomTodo = value;
                                },
                                decoration: InputDecoration(hintText: "Titre"),
                              ),
                              TextFormField(
                                onChanged: (String value) {
                                  descTodo = value;
                                },
                                decoration: InputDecoration(
                                    hintText: "Description"),
                              ),
                              ElevatedButton(
                                onPressed: () => _selectDate(context),
                                child: Text("Choose Date"),
                              ),
                              Text("${dateTodo}".split(' ')[0]),
                            ],
                          ),),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {
                                  createTodos();
                                  Navigator.of(context).pop();
                                },
                                child: Text("Ajouter"))
                          ],
                        );
                      }
                  )
          ),
          SpeedDialChild(
              child: Icon(Icons.add_a_photo),
              label: ('Todo photo'),
              onTap: () =>
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Ajouter une TODO"),
                          content: Form(child: Column(
                            children: <Widget>[
                              TextFormField(
                                onChanged: (String value) {
                                  nomTodo = value;
                                },
                                decoration: InputDecoration(hintText: "Titre"),
                              ),
                              TextFormField(
                                onChanged: (String value) {
                                  descTodo = value;
                                },
                                decoration: InputDecoration(
                                    hintText: "Description"),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  final result = await FilePicker.platform
                                      .pickFiles(
                                    allowMultiple: false,
                                    type: FileType.custom,
                                    allowedExtensions: ['png', 'jpg'],
                                  );

                                  if (result == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Pas de fichier !")
                                      ),
                                    );
                                    return null;
                                  }

                                  final path = result.files.single.path!;
                                  fileName = result.files.single.name;

                                  storage
                                      .uploadFile(path, fileName)
                                      .then((value) => print('Image ajoutée'));
                                },
                                child: Text("Choisir une image"),
                              ),
                            ],
                          ),),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {
                                  createTodosWithPicture();

                                  Navigator.of(context).pop();
                                },
                                child: Text("Ajouter"))
                          ],
                        );
                      }
                  )
          ),
          SpeedDialChild(
              child: Icon(Icons.check_box),
              label: ('Todo checkbox'),
              onTap: () =>
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Ajouter une TODO"),
                          content: Form(child: Column(
                            children: <Widget>[
                              TextFormField(
                                onChanged: (String value) {
                                  nomTodo = value;
                                },
                                decoration: InputDecoration(hintText: "Titre"),
                              ),
                              TextFormField(
                                onChanged: (String value) {
                                  descTodo = value;
                                },
                                decoration: InputDecoration(
                                    hintText: "Description"),
                              ),
                              ElevatedButton(
                                onPressed: () => _selectDate(context),
                                child: Text("Choisir une date"),
                              ),
                              Text("${dateTodo}".split(' ')[0]),
                              ElevatedButton(
                                onPressed: () => _selectTime(context),
                                child: Text("Choisir l'heure"),
                              ),
                              Text(timeTodo.toString()),
                              Container(
                                child:
                                Stack(
                                  fit: StackFit.loose,
                                  alignment: AlignmentDirectional.topEnd,
                                  children: [
                                    TextFormField(
                                      controller: _controller,
                                      onChanged: (String value) {
                                        listElement = value;
                                      },
                                      decoration: InputDecoration(
                                          hintText: "Élément de liste"),
                                    ),
                                    IconButton(onPressed: ajouterElementListe,
                                        icon: Icon(Icons.add))
                                  ],
                                ),
                              ),
                              /*
                              ListView.builder(
                                  itemCount: liste_checkbox.length,
                                  itemBuilder: (context, index) {

                                    List<String> checkBoxElements = liste_checkbox.keys.toList();

                                    return Text("checkBoxElements[index]");
                                  }
                              )
                              */
                            ],
                          ),
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
                      }
                  )
          ),
        ],
      ),
      body: StreamBuilder(
          stream: db.snapshots(),
          builder: (context, AsyncSnapshot snapshots) {
            _allResults.clear();
            if (snapshots.hasData) {
              return ListView.builder(
                  controller: _actualiserListe,
                  itemCount: snapshots.data?.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot = snapshots.data
                        .docs[index];

                    _allResults.add(documentSnapshot["TodoTitle"]);

                    String id = documentSnapshot.reference.id;

                    List<TodoDataModel> todoData = List.generate(
                        snapshots.data?.docs.length, (index) =>
                        TodoDataModel(
                            id,
                            documentSnapshot["TodoTitle"],
                            documentSnapshot["TododescTodo"],
                            documentSnapshot["TodoImage"],
                            documentSnapshot["TodoColor"],
                            documentSnapshot["TodoDate"],
                            documentSnapshot["TodoCheckbox"]));

                    String couleurString = documentSnapshot["TodoColor"]; //"0xFF" +

                    print("TODO TITLE :" + documentSnapshot["TodoTitle"]);

                    if (_todoAAffiches.contains(
                        documentSnapshot["TodoTitle"]) /* || _todoAAffiches.isEmpty*/) {
                      return SizedBox(
                          width: 50,
                          child: Card(
                              color: Color(int.parse(couleurString)),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (Context) =>
                                            TodoDetail(
                                                todoDataModel: todoData[index],
                                                couleurChoisie: documentSnapshot["TodoColor"])));
                                  },
                                  child: Column(
                                      children: <Widget>[
                                        FutureBuilder(
                                            future: storage.getImageURL(
                                                documentSnapshot["TodoImage"]),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<
                                                    String> snapshot) {
                                              if (snapshot.data != "" &&
                                                  snapshot.data != null) {
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
                                              } else {
                                                return SizedBox.shrink();
                                              }
                                            }
                                        ),
                                        ListTile(
                                          title: Text(
                                              documentSnapshot["TodoTitle"]),
                                          //documentSnapshot["TodoTitle"]
                                          subtitle: Text(formatDate(documentSnapshot["TodoDate"].toDate(), [dd, ".", mm, ".", yyyy, " " , hh, ":", nn])),
                                          trailing: IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  //todos.removeAt(index);
                                                  //todo le remove avec la firebase
                                                  deleteTodos(id);
                                                });
                                              }
                                          ),
                                        )
                                      ]
                                  )
                              )
                          )
                      );
                    } else {
                      return Text("Pas de todo correspondantes");
                      //return SizedBox.shrink();
                    }
                  });
            } else {
              return Text(
                'No Data...',
              );
            }
          }
      ),
    );
  }
}
