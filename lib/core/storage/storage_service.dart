import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  static final Reference _postersRef =
      FirebaseStorage.instance.ref().child('posters');

  static Future<String> uploadPoster(String id, XFile file) async {
    TaskSnapshot snapshot = await _postersRef
        .child('$id.jpg')
        .putFile(File(file.path), SettableMetadata(contentType: 'image/jpeg'));
    return await snapshot.ref.getDownloadURL();
  }
}
