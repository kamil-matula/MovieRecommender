import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:movie_recommender/models/movie.dart';
import 'package:movie_recommender/models/user.dart';

class DbService {
  static final CollectionReference<Map<String, dynamic>> _moviesRef =
      FirebaseFirestore.instance.collection('movies');
  static final CollectionReference<Map<String, dynamic>> _usersRef =
      FirebaseFirestore.instance.collection('users');

  static Stream<List<Movie>> watchListOfMovies() {
    return _moviesRef.snapshots().map((element) {
      return element.docs.map((movie) => Movie.fromJson(movie.data())).toList();
    });
  }

  static Future<List<Movie>> getListOfMovies() async {
    QuerySnapshot<Map<String, dynamic>> data = await _moviesRef.get();
    return data.docs.map((movie) => Movie.fromJson(movie.data())).toList();
  }

  static Future<void> addMovie(String id, Map<String, dynamic> data) async {
    await _moviesRef.doc(id).set(data);
  }

  static Future<void> deleteMovie(String id) async {
    await _moviesRef.doc(id).delete();
  }

  static Future<List<String>> getListOfAdmins() async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _usersRef.doc('admins').get();
    return List<String>.from(snapshot.data()?['listOfIds']);
  }

  static Stream<User?> watchUserWithPreferences() {
    String uid = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
    return _usersRef.doc(uid).snapshots().map((element) {
      Map<String, dynamic>? data = element.data();
      return data != null ? User.fromJson(data) : null;
    });
  }

  static Future<User?> getUserWithPreferences() async {
    String uid = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
    Map<String, dynamic>? data = (await _usersRef.doc(uid).get()).data();
    return data != null ? User.fromJson(data) : null;
  }

  static Future<void> updatePreferences(Map<String, dynamic> data) async {
    String uid = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
    await _usersRef.doc(uid).set(data);
  }
}
