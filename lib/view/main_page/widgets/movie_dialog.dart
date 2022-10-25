import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_recommender/constants/constant_assets.dart';
import 'package:movie_recommender/constants/constant_colors.dart';
import 'package:movie_recommender/constants/constant_texts.dart';

// TODO: This is temporary list only
const List<String> genres = ['Action', 'Fantasy', 'Comedy', 'Drama'];

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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(ADD_NEW_MOVIE, textAlign: TextAlign.center),
      content: SizedBox(
        width: 300,
        height: 450,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                PLACEHOLDER,
                width: 140,
                height: 140,
              ),
              _textField(MOVIE_TITLE, 300, titleController, 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _textField(DIRECTOR, 110, directorController, 20),
                  _textFieldDigitOnly(YEAR, 50, yearController),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: FORM_BACKGROUND_COLOR, width: 2.0),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        alignment: AlignmentDirectional.center,
                        value: selectedGenre,
                        items: genres.map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          },
                        ).toList(),
                        onChanged: (String? value) {
                          selectedGenre = value.toString();
                          if (mounted) setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(CANCEL),
        ),
        TextButton(
          onPressed: () {
            // TODO: POST data to database
            Navigator.of(context).pop();
          },
          child: const Text(OK),
        ),
      ],
    );
  }

  Widget _textField(
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

  Widget _textFieldDigitOnly(
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
  void dispose() {
    titleController.dispose();
    directorController.dispose();
    yearController.dispose();
    super.dispose();
  }
}
