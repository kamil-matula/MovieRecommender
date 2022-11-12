import 'package:cloud_firestore/cloud_firestore.dart';

class DbService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<List<String>> getListOfAdmins() async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection('users').doc('admins').get();

    return List<String>.from(snapshot.data()?['listOfIds']);
  }
}
