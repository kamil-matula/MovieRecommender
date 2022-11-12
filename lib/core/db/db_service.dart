import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_recommender/models/movie.dart';

class DbService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<List<String>> getListOfAdmins() async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection('users').doc('admins').get();
    return List<String>.from(snapshot.data()?['listOfIds']);
  }

  static Stream<List<Movie>> watchListOfMovies() {
    return _db.collection('movies').snapshots().map((element) {
      return element.docs.map((movie) => Movie.fromJson(movie.data())).toList();
    });
  }

  static Future<void> addMovie(String id, Map<String, dynamic> data) async {
    await _db.collection('movies').doc(id).set(data);
  }

  static Future<void> deleteMovie(String id) async {
    await _db.collection('movies').doc(id).delete();
  }
}
