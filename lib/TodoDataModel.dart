import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list_lma_tas_mas/CheckBoxState.dart';

class TodoDataModel{
  //String name, desc, check;

  String id,name, desc, image, color;
  Timestamp date;
  Map<String, bool> values = {};

  TodoDataModel(this.id, this.name, this.desc, this.image, this.color, this.date);
  //TodoDataModel(this.name, this.desc, this.check);
}