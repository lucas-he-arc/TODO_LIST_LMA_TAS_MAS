import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

/*
* Author(s) : Lucas Martinez
*/

class Storage{
  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(
    String filePath,
    String fileName,
    ) async {
      File file = File(filePath);

      try {
        await storage.ref('images/$fileName').putFile(file);
      } on firebase_core.FirebaseException catch (e){
        print(e);
      }
  }

  Future<String> getImageURL(String imageName) async{
    String imageUrl = await storage.ref('images/$imageName').getDownloadURL();
    return imageUrl;
  }


}