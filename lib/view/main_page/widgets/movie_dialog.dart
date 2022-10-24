import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_recommender/constants/constant_assets.dart';
import 'package:movie_recommender/constants/constant_colors.dart';
import 'package:movie_recommender/constants/constant_texts.dart';

// TODO: This is temporary list only
const List<String> genres = <String>['Action', 'Fantasy', 'Comedy', 'Drama'];

class MovieDialog extends StatefulWidget {
  const MovieDialog({Key? key}) : super(key: key);

  @override
  State<MovieDialog> createState() => _MovieDialogState();
}

class _MovieDialogState extends State<MovieDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController directorController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  String selectedGenre = genres.first;

  Widget textField(
    String label,
    double width,
    TextEditingController textEditingController,
    int lengthLimit,
  ) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: textEditingController,
        decoration: InputDecoration(labelText: label),
        inputFormatters: [LengthLimitingTextInputFormatter(lengthLimit)],
      ),
    );
  }

  Widget textFieldDigitOnly(
    String label,
    double width,
    TextEditingController textEditingController,
  ) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: textEditingController,
        decoration: InputDecoration(labelText: label),
        keyboardType: const TextInputType.numberWithOptions(),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9]+')),
          LengthLimitingTextInputFormatter(4)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        ADD_NEW_MOVIE,
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        width: 300,
        height: 450,
        child: Column(
          children: [
            Image.asset(
              PLACEHOLDER,
              width: 140,
              height: 140,
            ),
            textField(MOVIE_TITLE, 300, titleController, 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                textField(DIRECTOR, 110, directorController, 20),
                textFieldDigitOnly(YEAR, 50, yearController),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: FORM_BACKGROUND_COLOR,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      alignment: AlignmentDirectional.center,
                      value: selectedGenre,
                      items:
                          genres.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGenre = value.toString();
                        });
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: <Widget>[
        TextButton(
          // TODO: POST data to database
          onPressed: () => Navigator.pop(context),
          child: const Text(CANCEL),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(OK),
        ),
      ],
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    directorController.dispose();
    yearController.dispose();
    super.dispose();
  }
}
