import 'package:cloud_firestore/cloud_firestore.dart';

class TodoDataModel{
  //String name, desc, check;

  String id,name, desc, image, color;
  Timestamp date;
  Map<String, dynamic> checkbox;
  List<dynamic> tags;

  TodoDataModel(this.id, this.name, this.desc, this.image, this.color, this.date, this.checkbox, this.tags);
  //TodoDataModel(this.name, this.desc, this.check);
}