//import 'dart:html';
import 'package:date_format/date_format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:todo_list_lma_tas_mas/TodoDataModel.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_lma_tas_mas/storage_service.dart';

class TodoDetail extends StatefulWidget {
  //String taskName = "";
  final TodoDataModel todoDataModel;

  String couleurChoisie;

  TodoDetail({Key? key, required this.todoDataModel, required this.couleurChoisie}) : super(key: key);

  @override
  State<TodoDetail> createState() => _TodoDetailState();
}

class _TodoDetailState extends State<TodoDetail> {
  String listElement = "";
  var _controller = TextEditingController();

  //map firebase
  updateTodo(String newDescription){
    FirebaseFirestore.instance.collection("MesTodos").doc(widget.todoDataModel.id).update({"TododescTodo" : newDescription});
    //FirebaseFirestore.instance.collection("MesTodos").doc(todoDataModel.id).update({"TodoColor" : couleurChoisie});
    //todoDataModel.color = couleurChoisie;
  }

  addTask(String taskName){
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection("MesTodos").doc(widget.todoDataModel.name);

    //this.todoDataModel.values.putIfAbsent(taskName, () => false);

    documentReference.set({"listeTaches": {taskName : false}}, SetOptions(merge: true));
  }

  void ajouterElementListe(){
    if(listElement != ""){
      widget.todoDataModel.checkbox.addEntries([MapEntry(listElement, false)]);
      FirebaseFirestore.instance.collection("MesTodos").doc(widget.todoDataModel.id).update({"TodoCheckbox" : widget.todoDataModel.checkbox});

      _controller.clear();
      listElement = "";
    }
  }

  void supprimerElementListe(String key){
    widget.todoDataModel.checkbox.remove(key);
    FirebaseFirestore.instance.collection("MesTodos").doc(widget.todoDataModel.id).update({"TodoCheckbox" : widget.todoDataModel.checkbox});
  }

  @override
  Widget build(BuildContext context) {

    Map<String, dynamic> liste_checkbox = widget.todoDataModel.checkbox;
    print("VALUUUUUUUES " + liste_checkbox.toString());



    var docRef = FirebaseFirestore.instance
        .collection('MesTodos').doc(widget.todoDataModel.id);

    docRef.get().then((value) => print(value.data()));
    /*docRef.snapshots(includeMetadataChanges: true).listen((event) {
      print(event.);
    });*/
    String newDescription = widget.todoDataModel.desc;
    //TODO - Parcourir les items de la firebase
    return Scaffold(
        appBar: AppBar(title: Text(widget.todoDataModel.name),),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('MesTodos').doc(widget.todoDataModel.id).snapshots(),
          builder: (context, snapshot) {
            final Storage storage = Storage();
            if (!snapshot.hasData) {
              return Text("Loading");
            }
              return Container(
                color: Color(int.parse(widget.todoDataModel.color)),
                child: Column(
                  children: <Widget>[
                    FutureBuilder(
                        future: storage.getImageURL(widget.todoDataModel.image),
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
                      initialValue: widget.todoDataModel.desc,
                      onChanged: (String value){
                      newDescription = value;
                    },
                    ),
                    AboutListTile(
                        child:
                        Text(formatDate(widget.todoDataModel.date.toDate(), [dd, " ", MM, " ", yyyy, " " , hh, ":", nn]) ),

                    ),
                    IconButton(
                        icon: Icon(
                          Icons.color_lens,
                        ),
                        onPressed: () {
                          pickColor(context);
                        },
                      ),
                    Container(
                      child:
                      Stack(
                        fit: StackFit.loose,
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          TextFormField(
                            controller: _controller,
                            onChanged: (String value){
                              listElement = value;
                            },
                            decoration: InputDecoration(hintText: "Élément de liste"),
                          ),
                          IconButton(onPressed: ajouterElementListe, icon: Icon(Icons.add))
                        ],
                      ),
                    ),
                        Expanded(
                            flex: 2,
                            child:
                            ListView(
                              children: widget.todoDataModel.checkbox.keys.map((String key) {
                                return CheckboxListTile(
                                  secondary: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                    ),
                                    onPressed: () {
                                      print("MA NOUVELLE CLEEE " + key.toString());
                                      supprimerElementListe(key);
                                    },
                                  ),
                                  controlAffinity: ListTileControlAffinity.leading,
                                  title: Text(key.toString()),
                                  value: liste_checkbox[key],
                                  activeColor: Colors.white,
                                  checkColor: Color(int.parse(widget.couleurChoisie)),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      widget.todoDataModel.checkbox[key] = value;
                                      FirebaseFirestore.instance.collection("MesTodos").doc(widget.todoDataModel.id).update({"TodoCheckbox" : widget.todoDataModel.checkbox});
                                    });
                                  },
                                );
                              }).toList(),
                            ),
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
      widget.couleurChoisie = splitted[1].substring(0, splitted[1].length - 1);
    },
  );

  void changeColorOfCard() {
    //FirebaseFirestore.instance.collection("MesTodos").doc(todoDataModel.id).update({"TodoColor" : couleurChoisie});
    FirebaseFirestore.instance.collection("MesTodos").doc(widget.todoDataModel.id).update({"TodoColor" : widget.couleurChoisie});
    widget.todoDataModel.color = widget.couleurChoisie;
  }
}
