import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_recommender/core/db/db_service.dart';

/// Cubit responsible for checking if logged user is admin or not.
class PermissionCubit extends Cubit<bool?> {
  PermissionCubit() : super(null) {
    unawaited(_checkIfAdmin());
  }

  /// Checks if current user is admin or not and emits new state.
  Future<void> _checkIfAdmin() async {
    try {
      List<String> admins = await DbService.getListOfAdmins();
      String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      emit(admins.contains(uid));
    } catch (_) {
      emit(false);
    }
  }
}
