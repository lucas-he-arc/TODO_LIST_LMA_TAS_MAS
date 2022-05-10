import 'package:todo_list_lma_tas_mas/CheckBoxState.dart';

class TodoDataModel{
  //String name, desc, check;
  String name, desc;
  Map<String, bool> values = {};

  TodoDataModel(this.name, this.desc);
  //TodoDataModel(this.name, this.desc, this.check);
}