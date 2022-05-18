import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.red),
    home: const SplashScreen(),
  ));

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Lottie.asset('assets/loading.json'),
        backgroundColor: Colors.white,
        nextScreen: AppTODO(),
      splashIconSize : 250,
      duration : 2500,
      pageTransitionType: PageTransitionType.fade,
      animationDuration: const Duration(seconds: 1),
    );
  }
}


class AppTODO extends StatefulWidget {
  const AppTODO({Key? key}) : super(key: key);

  @override
  State<AppTODO> createState() => _AppTODOState();
}

class _AppTODOState extends State<AppTODO> {

  List todos = [];
  String input = "";
  Color _customColor = Colors.red;

  @override
  void initState() {
    super.initState();
    todos.add("item1");
    todos.add("item2");
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
                        onPressed: (){
                          setState((){
                            todos.add(input);
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
          itemCount : todos.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                key: Key(todos[index]),
                child: Card(
/*                  child: ListTile(
                    title: Text(todos[index]),
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
                  ),*/
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 350,
                          height: 150,
                          child: const Center(
                            child: Text('Color is : ' ),
                          ),
                          decoration: BoxDecoration(color : _customColor),
                        ),
                        ColorPicker(
                            onChanged: (value) {
                              setState(() {
                                _customColor = value;
                              });
                            },
                            color : Colors.red)
                      ],
                    ),
                )
            );
          },
      ),
      );
  }
}
