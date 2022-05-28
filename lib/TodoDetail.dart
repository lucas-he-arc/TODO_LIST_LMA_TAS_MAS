//import 'dart:html';
import 'package:date_format/date_format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:todo_list_lma_tas_mas/TodoDataModel.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_lma_tas_mas/storage_service.dart';

class TodoDetail extends StatelessWidget {
  //String taskName = "";
  final TodoDataModel todoDataModel;

  String couleurChoisie;


  TodoDetail({Key? key, required this.todoDataModel, required this.couleurChoisie}) : super(key: key);

  //map firebase
  //Map<String,bool> tasks = {"TaskTitle" : taskName, "TododescTodo" : descTodo};

  updateTodo(String newDescription){
    FirebaseFirestore.instance.collection("MesTodos").doc(todoDataModel.id).update({"TododescTodo" : newDescription});
    //FirebaseFirestore.instance.collection("MesTodos").doc(todoDataModel.id).update({"TodoColor" : couleurChoisie});
    //todoDataModel.color = couleurChoisie;
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
            final Storage storage = Storage();
            if (!snapshot.hasData) {
              return Text("Loading");
            }
              return Container(
                color: Color(int.parse(todoDataModel.color)),
                child: Column(
                  children: <Widget>[
                    FutureBuilder(
                        future: storage.getImageURL(todoDataModel.image),
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
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      decoration: InputDecoration(hintText : "Note"),
                      initialValue: todoDataModel.desc,
                      onChanged: (String value){
                      newDescription = value;
                    },
                    ),
                    AboutListTile(
                        child:
                        Text(formatDate(todoDataModel.date.toDate(), [dd, " ", MM, " ", yyyy, " " , hh, ":", nn]) ),

                    ),
                    IconButton(
                        icon: Icon(
                          Icons.color_lens,
                        ),
                        onPressed: () {
                          pickColor(context);
                        },
                      ),
            ]
              ));
          },
        ),
        floatingActionButton: FloatingActionButton(
          focusColor: Colors.green,
          onPressed: () => updateTodo(newDescription),
          child: Icon(Icons.save)

      ),
    );
  }

  //void buildColorPicker() => ColorPicker(onChanged: onChanged)
void pickColor(BuildContext context) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Container(
          width: 200.0,
          height: 550.0,
          child:Column(
              children: <Widget>[
                buildColorPicker(),
                TextButton(
                    onPressed: (){
                      changeColorOfCard();
                      Navigator.of(context).pop();
                    },
                    child: Text("Ajouter")
                )
              ]
          )



        /*mainAxisSize: MainAxisSize.min,
        children: [
          buildColorPicker()
        ],*/
      ),
    ));

  Widget buildColorPicker() => ColorPicker(
    onChanged: (value) {
      //couleurChoisie = value.toString();
      var splitted = value.toString().split('(');
      couleurChoisie = splitted[1].substring(0, splitted[1].length - 1);
    },
  );

  void changeColorOfCard() {
    //FirebaseFirestore.instance.collection("MesTodos").doc(todoDataModel.id).update({"TodoColor" : couleurChoisie});
    FirebaseFirestore.instance.collection("MesTodos").doc(todoDataModel.id).update({"TodoColor" : couleurChoisie});
    todoDataModel.color = couleurChoisie;
  }
}
