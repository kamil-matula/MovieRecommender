import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit responsible for checking if logged user is admin or not.
class PermissionCubit extends Cubit<bool?> {
  PermissionCubit() : super(null) {
    unawaited(_checkIfAdmin());
  }

  /// Checks if current user is admin or not and emits new state.
  Future<void> _checkIfAdmin() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc('admins')
              .get();

      List<String> admins = List<String>.from(snapshot.data()?['listOfIds']);
      String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      emit(admins.contains(uid));
    } catch (_) {
      emit(false);
    }
  }
}
