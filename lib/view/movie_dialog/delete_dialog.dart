import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_recommender/constants/constant_texts.dart';
import 'package:movie_recommender/core/navigation_manager.dart';

class DeleteDialog extends StatefulWidget {
  const DeleteDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        DELETE_ACCOUNT,
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        width: 200,
        height: 90,
        child: Column(
          children: const [
            Icon(
              Icons.exit_to_app,
              size: 42,
            ),
            SizedBox(height: 20),
            Text(ACTION_UNDONE, style: TextStyle(color: Colors.grey))
          ],
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actionsPadding: EdgeInsets.zero,
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text(CANCEL),
        ),
        TextButton(
          onPressed: _deleteAccount,
          child: const Text(OK),
        ),
      ],
    );
  }

  Future<void> _deleteAccount() async {
    FirebaseAuth.instance.currentUser?.delete();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NavigationManager(),
      ),
    );
  }
}
