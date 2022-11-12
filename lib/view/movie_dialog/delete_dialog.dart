import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_recommender/constants/texts.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        DELETE_ACCOUNT,
        textAlign: TextAlign.center,
      ),
      content: const Text(
        ACTION_UNDONE,
        style: TextStyle(color: Colors.grey),
        textAlign: TextAlign.center,
      ),
      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(CANCEL),
        ),
        TextButton(
          onPressed: () async => _deleteAccount(context),
          child: const Text(OK),
        ),
      ],
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    FirebaseAuth.instance.currentUser?.delete().then((_) {
      Navigator.of(context).pop(true);
    }).catchError((error) {
      Fluttertoast.showToast(
        msg: TRY_AGAIN,
        backgroundColor: Colors.grey,
      );
    });
  }
}
