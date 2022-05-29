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
  List<dynamic> tags = [];
  String monTag = "";
  var _controllerTag = TextEditingController();
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
  }

  void ajouterElementListe(){
    tags.add(monTag);
    _controllerTag.clear();
    monTag = "";
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

  void ajouterElementListeCheckbox() {
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
          //print(_todoAAffiches);
        }
      }
    }else{
      _todoAAffiches.addAll(_allResults);
    }

    db.doc("temp").set({"TodoTitle" : "xxx", "TododescTodo" : "xxx", "TodoDate" : dateTodo, "TodoImage" : "xx", "TodoColor" : colorTodo, "TodoCheckbox" : {}, "tags" : []});
    db.doc("temp").delete();
  }

  createTodos(){
    //map
    Map<String,Object> todos = {"TodoTitle" : nomTodo, "TododescTodo" : descTodo, "TodoDate" : dateTodo, "TodoImage" : fileName, "TodoColor" : colorTodo,"TodoCheckbox": liste_checkbox, "tags" : tags};
    db.add(todos);
    tags.clear();
    _allResults.add(nomTodo);
    liste_checkbox.clear();
  }

  createTodosWithPicture(){
    Map<String,Object> todos = {"TodoTitle" : nomTodo, "TododescTodo" : descTodo, "TodoDate" : dateTodo, "TodoImage" : fileName, "TodoColor" : colorTodo,"TodoCheckbox": liste_checkbox, "tags" : tags};
    db.add(todos);
    tags.clear();
    fileName = "";
    _allResults.add(nomTodo);
    liste_checkbox.clear();
  }

  deleteTodos(String toDoToDelete) {
    db.doc(toDoToDelete).delete();
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes TODOs")
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
                  builder: (BuildContext context){
                    return StatefulBuilder(
                        builder: (context, setState){
                        return AlertDialog(
                        title: Text("Ajouter une TODO"),
                        content: Form(child: Column(
                          children: <Widget> [
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
                            ),
                            ElevatedButton(
                              onPressed: () => setState(() => _selectDate(context)),
                              child: Text("Choose Date"),
                            ),
                            Text("${dateTodo}".split(' ')[0]),

                            Container(
                              child:
                              Stack(
                                fit: StackFit.loose,
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  TextFormField(
                                    controller: _controllerTag,
                                    onChanged: (String value){
                                      monTag = value;
                                    },
                                    decoration: InputDecoration(hintText: "Tag"),
                                  ),
                                  IconButton(icon: Icon(Icons.add),
                                      onPressed: (){
                                        setState(() {
                                          ajouterElementListe();
                                        });
                                      }
                                  )
                                ],
                              ),
                            ),
                            Container(
                                margin: const EdgeInsets.only(top: 15.0),
                                child: Wrap( direction: Axis.horizontal, alignment: WrapAlignment.start,
                                  children: [
                                    for (var tag in tags) Container(
                                        decoration: BoxDecoration(
                                            color: Colors.teal,
                                            borderRadius: BorderRadius.circular(100.0)),
                                        padding: const EdgeInsets.only(left: 8.0,right: 8.0, top: 5.0, bottom: 5.0),
                                        margin: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
                                        child: Wrap (children:[
                                          const Icon(
                                            Icons.local_offer_outlined,
                                            color: Colors.amberAccent,
                                            size: 20.0,
                                          ),
                                          Text(" " + tag, style: const TextStyle(fontSize: 15.0, color: Colors.white))
                                        ],)
                                    )
                                    //margin: const EdgeInsets.only(right: 15.0),
                                  ],
                                )
                            ),
                            IconButton(icon: Icon(Icons.delete_rounded),
                                onPressed: (){
                                  setState(() {
                                    tags.clear();
                                  });
                                }
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

                  }
                )
          ),
          SpeedDialChild(
              child: Icon(Icons.add_a_photo),
              label: ('Todo photo'),
              onTap: () =>
                  showDialog(
                      context: context,
                        builder: (BuildContext context){
                        return StatefulBuilder(
                          builder: (context, setState){
                          return AlertDialog(
                            title: Text("Ajouter une TODO"),
                            content: Form(child: Column(
                              children: <Widget> [
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
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  final result = await FilePicker.platform.pickFiles(
                                    allowMultiple: false,
                                    type:FileType.custom,
                                    allowedExtensions: ['png', 'jpg'],
                                  );

                                  if(result == null){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:Text("Pas de fichier !")
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
                                onPressed: (){
                                  createTodosWithPicture();

                                  Navigator.of(context).pop();
                                },
                                child: Text("Ajouter"))
                          ],
                          );
                          });

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
                                    IconButton(onPressed: ajouterElementListeCheckbox,
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

                              String id = documentSnapshot.reference.id;

                List<TodoDataModel> todoData = List.generate(snapshots.data?.docs.length, (index) =>
                    TodoDataModel(id,documentSnapshot["TodoTitle"],documentSnapshot["TododescTodo"], documentSnapshot["TodoImage"], documentSnapshot["TodoColor"],documentSnapshot["TodoDate"] ,documentSnapshot["TodoCheckbox"], documentSnapshot["tags"]));

                              String couleurString = documentSnapshot["TodoColor"];//"0xFF" +

                              if(_todoAAffiches.isEmpty && _searchController.text == ""){
                                show = true;
                              }else{
                                show = false;
                              }
                if(documentSnapshot["TodoTitle"] != "xxx"){

                  if(_todoAAffiches.contains(documentSnapshot["TodoTitle"]) || show){
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
                                        title: Text(documentSnapshot["TodoTitle"]),//documentSnapshot["TodoTitle"]
                                        subtitle: Text(formatDate(documentSnapshot["TodoDate"].toDate(), [dd, " ", MM, " ", yyyy, " " , hh, ":", nn]).toString()),
                                        trailing: IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                            ),
                                            onPressed: (){
                                              setState(() {
                                                //todos.removeAt(index);
                                                //todo le remove avec la firebase
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
                                              //margin: const EdgeInsets.only(right: 15.0),
                                            ],
                                          )
                                      ),
                                    ]
                                )
                            )
                        )
                    );
                  }else{
                    //return Text("Pas de todo correspondantes");
                    return SizedBox.shrink();
                  }
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
