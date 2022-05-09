import 'package:flutter/material.dart';
import 'package:todo_list_lma_tas_mas/CheckBoxState.dart';
import 'package:todo_list_lma_tas_mas/TodoDataModel.dart';
import 'package:todo_list_lma_tas_mas/TodoDetail.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.red),
    home: AppTODO(),
  ));

class AppTODO extends StatefulWidget {
  const AppTODO({Key? key}) : super(key: key);

  @override
  State<AppTODO> createState() => _AppTODOState();
}

class _AppTODOState extends State<AppTODO> {

  //List todos = [];
  String input = "";

  final TodoDataModel todoToAdd = TodoDataModel('','', false);

  static List<String> todoName = ["todo1","todo2","todo3"];
  static List<String> todoDescription = ["Description de la TODO 1","Description de la TODO 2","Description de la TODO 3"];
  
  final List<TodoDataModel> todoData = List.generate(
      todoName.length,
          (index) => TodoDataModel('${todoName[index]}', '${todoDescription[index]}', false));

  /*@override
  void initState() {
    super.initState();
    todos.add("item1");
    todos.add("item2");
  }*/

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
                  content: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Titre de la TODO',
                        ),
                        onChanged: (String value){
                          todoToAdd.name = value;
                          //input = value;
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Description de la TODO',
                        ),
                        onChanged: (String value){
                          todoToAdd.desc = value;
                          //input = value;
                        },
                      )
                    ],
                  ),
                  /*content: TextField(
                    onChanged: (String value){
                      input = value;
                    },
                  ),*/
                  actions: <Widget>[
                    TextButton(
                        onPressed: (){
                          setState((){
                            //todos.add(input);
                            todoName.add(input);
                            //todoData.add(todoToAdd);
                          });
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
