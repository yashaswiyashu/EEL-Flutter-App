import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> uploadFile(
    String filePath,
    String fileName,
  ) async {
    File file = File(filePath);

    try {
      await storage.ref('Images/$fileName').putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<ListResult> ListFiles() async {
    ListResult results = await storage.ref('Images').listAll();

    results.items.forEach((Reference ref) {
      print('Found file: $ref');
    });
    return results;
  } 

  Future<String> downloadURL(String imageName) async {
    String downloadURL = await storage.ref('Images/$imageName').getDownloadURL();

    return downloadURL;
  }
}