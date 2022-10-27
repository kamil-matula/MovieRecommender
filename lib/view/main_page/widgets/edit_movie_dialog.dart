import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_recommender/constants/constant_assets.dart';
import 'package:movie_recommender/constants/constant_colors.dart';
import 'package:movie_recommender/constants/constant_genres.dart';
import 'package:movie_recommender/constants/constant_texts.dart';
import 'package:movie_recommender/models/movie.dart';

// TODO: Prepare cubit for this dialog (changing image and adding movie)
class EditMovieDialog extends StatefulWidget {
  const EditMovieDialog({Key? key}) : super(key: key);

  @override
  State<EditMovieDialog> createState() => _EditMovieDialogState();
}

class _EditMovieDialogState extends State<EditMovieDialog> {
  // Poster:
  final ImagePicker _picker = ImagePicker();
  XFile? _file;

  // Details:
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _directorController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  String selectedGenre = genres.first;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(EDIT_MOVIE, textAlign: TextAlign.center),
      content: SizedBox(
        width: 300,
        height: 450,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _imageContainer(),
              _textField(MOVIE_TITLE, 300, _titleController, 50),
              _textField(DIRECTOR, 300, _directorController, 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _textFieldDigitOnly(YEAR, 80, _yearController),
                  _dropdown(),
                ],
              )
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text(CANCEL),
        ),
        TextButton(
          onPressed: _addMovie,
          child: const Text(OK),
        ),
      ],
    );
  }

  Widget _imageContainer() {
    return GestureDetector(
      onTap: _chooseImageFromGallery,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: _file != null
                ? Image.file(
              File(_file!.path),
              height: 140,
              width: 100,
              fit: BoxFit.cover,
            )
                : Image.asset(
              PLACEHOLDER,
              height: 140.0,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.blue,
              ),
              width: 30.0,
              height: 30.0,
              child: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 17.5,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _dropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: FORM_BACKGROUND_COLOR,
          width: 2.0,
        ),
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

  Future<void> _chooseImageFromGallery() async {
    _file = await _picker.pickImage(source: ImageSource.gallery);
    if (mounted) setState(() {});
  }

  Future<void> _addMovie() async {
    String title = _titleController.text;
    String director = _directorController.text;
    int? year = int.tryParse(_yearController.text);
    String? url;

    if (title.isEmpty || director.isEmpty || year == null) {
      Fluttertoast.showToast(
        msg: 'Invalid data!',
        backgroundColor: Colors.grey,
      );
      return;
    }

    // Upload poster to Firebase Storage:
    String docName = '${title}_$year';
    if (_file != null) {
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref()
          .child('posters')
          .child('$docName.jpg')
          .putFile(
        File(_file!.path),
        SettableMetadata(contentType: 'image/jpeg'),
      );
      url = await snapshot.ref.getDownloadURL();
    }

    // Prepare object:
    Movie movie = Movie(
      title: title,
      director: director,
      genre: selectedGenre,
      year: year,
      url: url,
    );

    // Save object in Firestore Database:
    FirebaseFirestore.instance
        .collection('movies')
        .doc(docName)
        .set(movie.toJson());

    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _directorController.dispose();
    _yearController.dispose();
    super.dispose();
  }
}
