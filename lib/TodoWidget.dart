import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:todo_list_lma_tas_mas/storage_service.dart';
import 'package:todo_list_lma_tas_mas/utilities.dart';

import 'PushNotification.dart';

class TodoWidget{

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
List<dynamic> tags = [];
String monTag = "";
var _controller = TextEditingController();
var _controllerTag = TextEditingController();
final db = FirebaseFirestore.instance.collection("MesTodos");
late NotificationWeekAndTime dateAffiche = new NotificationWeekAndTime(date: DateTime.now(), timeOfDay: TimeOfDay.now());
List _allResults = [];

Map<String, List<String>> _allResultsTag = new Map();

void ajouterElementListe(){
  tags.add(monTag);
  _controllerTag.clear();
  monTag = "";
}

/*
* Author(s) : Téo Assunçao, Lucas Martinez, Marc-Antoine Sudan
*/
createTodos(){
  Map<String,Object> todos = {"TodoTitle" : nomTodo, "TododescTodo" : descTodo, "TodoDate" : dateTodo, "TodoImage" : fileName, "TodoColor" : colorTodo,"TodoCheckbox": liste_checkbox, "tags" : tags};
  db.add(todos);

  fileName = "";

  _allResults.add(nomTodo);

  List<String> tagList = [];

  for(String tag in tags){
    tagList.add(tag);
  }

  _allResultsTag.putIfAbsent(nomTodo, () => tagList);

  tagList = [];
  liste_checkbox.clear();
  tags.clear();
}
/*
* Author(s) : Lucas Martinez
*/
void ajouterElementListeCheckbox() {
  liste_checkbox.addEntries([MapEntry(listElement, false)]);
  _controller.clear();
  listElement = "";

}

/*
* Author(s) : Téo Assunçao, Lucas Martinez, Marc-Antoine Sudan
*/
SpeedDialChild buildSimpleTodo(BuildContext context) {
  return SpeedDialChild(
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
                        content: Form(
                            child: SingleChildScrollView(
                              child: Column(
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
                                    onPressed: () async{
                                      NotificationWeekAndTime? pickedSchedule = await pickSchedule(context);

                                      if(pickedSchedule != null){
                                        createReminderNotification(pickedSchedule);
                                        setState(() => dateAffiche = pickedSchedule);
                                      }
                                    },
                                    child: Text("Choisir une date"),
                                  ),
                                  Text("${dateAffiche.date.toLocal()}".split(' ')[0]),
                                  Text("${dateAffiche.timeOfDay.hour}".split(' ')[0] + "h" + "${dateAffiche.timeOfDay.minute}".split(' ')[0]),

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
                              ),
                            )),
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
  );
}
/*
* Author(s) : Téo Assunçao, Lucas Martinez
*/
SpeedDialChild buildImageTodo(BuildContext context) {
  final Storage storage = Storage();
  return SpeedDialChild(
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
                        content: Form(
                            child:SingleChildScrollView(
                              child: Column(
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
                                    onPressed: () async{
                                      //createNotification();
                                      NotificationWeekAndTime? pickedSchedule = await pickSchedule(context);

                                      if(pickedSchedule != null){
                                        createReminderNotification(pickedSchedule);
                                        setState(() => dateAffiche = pickedSchedule);
                                      }
                                    },
                                    child: Text("Choisir une date"),
                                  ),
                                  Text("${dateAffiche.date.toLocal()}".split(' ')[0]),
                                  Text("${dateAffiche.timeOfDay.hour}".split(' ')[0] + "h" + "${dateAffiche.timeOfDay.minute}".split(' ')[0]),

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
                              ),)),
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
  );
}

/*
* Author(s) : Lucas Martinez
*/
SpeedDialChild buildCheckboxTodo(BuildContext context){
  return SpeedDialChild(
      child: Icon(Icons.check_box),
      label: ('Todo checkbox'),
      onTap: () =>
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                    builder: (context, setState){
                      return AlertDialog(
                        title: Text("Ajouter une TODO"),
                        content: Form(
                            child: SingleChildScrollView(
                              child: Column(
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
                                    onPressed: () async{
                                      NotificationWeekAndTime? pickedSchedule = await pickSchedule(context);

                                      if(pickedSchedule != null){
                                        createReminderNotification(pickedSchedule);
                                        setState(() => dateAffiche = pickedSchedule);
                                      }
                                    },
                                    child: Text("Choisir une date"),
                                  ),
                                  Text("${dateAffiche.date.toLocal()}".split(' ')[0]),
                                  Text("${dateAffiche.timeOfDay.hour}".split(' ')[0] + "h" + "${dateAffiche.timeOfDay.minute}".split(' ')[0]),

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
                                        ],
                                      )
                                  ),
                                  IconButton(icon: Icon(Icons.delete_rounded),
                                      onPressed: (){
                                        setState(() {
                                          tags.clear();
                                        });
                                      }
                                  ),
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
                                        IconButton(
                                            onPressed: (){
                                              setState(() {
                                                ajouterElementListeCheckbox();
                                              });
                                            },
                                            icon: Icon(Icons.add))
                                      ],
                                    ),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(top: 15.0),
                                      child: Wrap( direction: Axis.horizontal, alignment: WrapAlignment.start,
                                        children: [
                                          for(var v in liste_checkbox.keys) Container(
                                              child: Row(children:[
                                                Text(" " + v.toString())
                                              ])

                                          )

                                        ],
                                      )
                                  ),
                                ],
                              ),
                            )),
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
              }
          )
  );

}

}