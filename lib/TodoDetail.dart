//import 'dart:html';
import 'package:date_format/date_format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:todo_list_lma_tas_mas/TodoDataModel.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_lma_tas_mas/storage_service.dart';

class TodoDetail extends StatefulWidget {
  final TodoDataModel todoDataModel;

  String couleurChoisie;

  TodoDetail({Key? key, required this.todoDataModel, required this.couleurChoisie}) : super(key: key);

  @override
  State<TodoDetail> createState() => _TodoDetailState();
}

class _TodoDetailState extends State<TodoDetail> {
  String listElement = "";
  String monTag = "";
  var _controller = TextEditingController();
  var _controllerTag = TextEditingController();

  /*
* Author(s) : Téo Assunçao, Lucas Martinez
*/
  updateTodo(String newDescription){
    FirebaseFirestore.instance.collection("MesTodos").doc(widget.todoDataModel.id).update({"TododescTodo" : newDescription});
  }

  /*
* Author(s) :Lucas Martinez
*/
  void ajouterElementListe(){
    if(listElement != ""){
      widget.todoDataModel.checkbox.addEntries([MapEntry(listElement, false)]);
      FirebaseFirestore.instance.collection("MesTodos").doc(widget.todoDataModel.id).update({"TodoCheckbox" : widget.todoDataModel.checkbox});

      _controller.clear();
      listElement = "";
    }
  }

/*
* Author(s) : Marc-Antoine Sudan
*/
  void ajouterElementListeTag(){
    if(monTag != ""){
      widget.todoDataModel.tags.add(monTag);
      FirebaseFirestore.instance.collection("MesTodos").doc(widget.todoDataModel.id).update({"tags" : widget.todoDataModel.tags});

      _controllerTag.clear();
      monTag = "";
    }
  }
/*
* Author(s) :Lucas Martinez
*/
  void supprimerElementListe(String key){
    widget.todoDataModel.checkbox.remove(key);
    FirebaseFirestore.instance.collection("MesTodos").doc(widget.todoDataModel.id).update({"TodoCheckbox" : widget.todoDataModel.checkbox});
  }
 /*
* Author(s) : Marc-Antoine Sudan
*/
  void supprimerTag(String value){
    widget.todoDataModel.tags.remove(value);
    FirebaseFirestore.instance.collection("MesTodos").doc(widget.todoDataModel.id).update({"tags" : widget.todoDataModel.tags});
  }


  /*
* Author(s) : Téo Assunçao, Lucas Martinez, Marc-Antoine Sudan
*/
  @override
  Widget build(BuildContext context) {

    Map<String, dynamic> liste_checkbox = widget.todoDataModel.checkbox;

    var docRef = FirebaseFirestore.instance
        .collection('MesTodos').doc(widget.todoDataModel.id);

    docRef.get().then((value) => print(value.data()));
    String newDescription = widget.todoDataModel.desc;
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                    /*
                    * Author(s) : Téo Assunçao, Lucas Martinez
                    */
                    FutureBuilder(
                        future: storage.getImageURL(widget.todoDataModel.image),
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot){

                          if(snapshot.data != "" && snapshot.data != null){

                            return Container(
                              width: 500,
                              height: 200,
                              child:
                              Image.network(
                                snapshot.data!,
                                fit: BoxFit.contain,
                              ),
                            );
                          }else{
                            return SizedBox.shrink();
                          }
                        }
                    ),
                    /*
                    * Author(s) : Téo Assunçao
                    */
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      decoration: InputDecoration(hintText : "Note"),
                      initialValue: widget.todoDataModel.desc,
                      onChanged: (String value){
                      newDescription = value;
                    },
                    ),
                    /*
                    * Author(s) : Lucas Martinez
                    */
                    ListTile(
                      title: Text(formatDate(widget.todoDataModel.date.toDate(), [dd, " ", MM, " ", yyyy, " " , hh, ":", nn]) ),
                    ),
                    /*
                    * Author(s) : Marc-Antoine Sudan
                    */
                    Container(
                        margin: const EdgeInsets.all(0.0),
                        child: Wrap(
                          children: [
                            for (var tag in widget.todoDataModel.tags) Container(
                                decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.circular(100.0)),
                                padding: const EdgeInsets.only(left: 8.0,right: 8.0, top: 5.0, bottom: 5.0),
                                margin: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
                                child: Wrap (children: [
                                  const Icon(
                                    Icons.local_offer_outlined,
                                    color: Colors.amberAccent,
                                    size: 25.0,
                                  ),
                                  Text(tag, style: TextStyle(fontSize: 15.0, color: Colors.white)),

                                SizedBox(
                                  height: 15.0,
                                  width: 15.0,
                                  child: IconButton(icon: Icon(Icons.delete),
                                      onPressed: (){
                                        setState(() {
                                          supprimerTag(tag);
                                        });
                                      }
                                  ))
                                ],)
                            ),
                          ],
                        )
                    ),
                    /*
                    * Author(s) : Marc-Antoine Sudan
                    */
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
                                ajouterElementListeTag();
                              }
                          )
                        ],
                      ),
                    ),
                    /*
                    * Author(s) : Marc-Antoine Sudan, Téo Assunçao
                    */
                    IconButton(
                        icon: Icon(
                          Icons.color_lens,
                        ),
                        onPressed: () {
                          pickColor(context);
                        },
                      ),
                    /*
                    * Author(s) : Lucas Martinez
                    */
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
                    /*
                    * Author(s) : Lucas Martinez
                    */
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
      /*
       * Author(s) : Téo Assunçao
        */
        floatingActionButton: FloatingActionButton(
          focusColor: Colors.green,
          onPressed: () => updateTodo(newDescription),
          child: Icon(Icons.save)
      ),
    );
  }

  /*
   * Author(s) : Marc-Antoine Sudan, Téo Assunçao
   */
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
      ),
    ));
  /*
   * Author(s) : Marc-Antoine Sudan, Téo Assunçao
   */
  Widget buildColorPicker() => ColorPicker(
    onChanged: (value) {
      var splitted = value.toString().split('(');
      widget.couleurChoisie = splitted[1].substring(0, splitted[1].length - 1);
    },
  );

  /*
   * Author(s) : Marc-Antoine Sudan, Téo Assunçao
   */
  void changeColorOfCard() {
    FirebaseFirestore.instance.collection("MesTodos").doc(widget.todoDataModel.id).update({"TodoColor" : widget.couleurChoisie});
    widget.todoDataModel.color = widget.couleurChoisie;
  }
}
