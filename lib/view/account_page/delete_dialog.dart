import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_recommender/constants/texts.dart';
import 'package:movie_recommender/core/auth/auth_cubit.dart';

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
          onPressed: () async {
            bool hasDeleted = await context.read<AuthCubit>().deleteAccount();
            Navigator.of(context).pop(hasDeleted);
          },
          child: const Text(OK),
        ),
      ],
    );
  }
}
