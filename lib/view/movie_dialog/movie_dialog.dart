import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_recommender/constants/constant_assets.dart';
import 'package:movie_recommender/constants/constant_colors.dart';
import 'package:movie_recommender/constants/constant_genres.dart';
import 'package:movie_recommender/constants/constant_movie_attributes.dart';
import 'package:movie_recommender/constants/constant_texts.dart';
import 'package:movie_recommender/constants/constant_typography.dart';
import 'package:movie_recommender/models/movie.dart';
import 'package:movie_recommender/models/movie_attribute.dart';
import 'package:movie_recommender/view/widgets/input_field.dart';

// TODO: Prepare cubit for this dialog (changing image and adding movie)
class MovieDialog extends StatefulWidget {
  const MovieDialog({Key? key}) : super(key: key);

  @override
  State<MovieDialog> createState() => _MovieDialogState();
}

class _MovieDialogState extends State<MovieDialog> {
  // Poster:
  final ImagePicker _picker = ImagePicker();
  XFile? _file;

  // Details:
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _directorController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  String _selectedGenre = genres.first;
  final List<MovieAttribute> _attributes = movie_attributes();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(ADD_NEW_MOVIE, textAlign: TextAlign.center),
      content: SizedBox(
        width: 300,
        height: 600,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _imageContainer(),
              const SizedBox(height: 15),
              CustomInputField(
                controller: _titleController,
                labelText: MOVIE_TITLE,
                lengthLimit: 200,
              ),
              const SizedBox(height: 15),
              CustomInputField(
                controller: _directorController,
                labelText: DIRECTOR,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomInputField(
                    controller: _yearController,
                    labelText: YEAR,
                    width: 120,
                    lengthLimit: 4,
                    digitOnly: true,
                  ),
                  _dropdown(),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(MOVIE_ATTRIBUTES, style: MOVIE_HEADER_STYLE),
              ),
              // Column(
              //   children: _movieAttributes(),
              // )
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _attributes.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _attributes[index].name,
                          style: MOVIE_ATTRIBUTE_STYLE,
                        ),
                        RatingBar.builder(
                          maxRating: 5,
                          itemSize: 28,
                          allowHalfRating: true,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (_, __) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            _attributes[index].value = (rating * 2).toInt();
                          },
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
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
          value: _selectedGenre,
          items: genres.map<DropdownMenuItem<String>>(
            (String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            },
          ).toList(),
          onChanged: (String? value) {
            _selectedGenre = value.toString();
            if (mounted) setState(() {});
          },
        ),
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
    String? poster_url;

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
      poster_url = await snapshot.ref.getDownloadURL();
    }

    // Prepare object:
    Movie movie = Movie(
      title: title,
      director: director,
      genre: _selectedGenre,
      year: year,
      poster_url: poster_url,
      attributes: _attributes,
    );

    // Save object in Firestore Database:
    FirebaseFirestore.instance
        .collection('movies')
        .doc(docName)
        .set(jsonDecode(jsonEncode(movie.toJson())));

    // _resetAttributes();
    if (mounted) Navigator.of(context).pop();
  }

  // void _resetAttributes() {
  //   for (var i = 0; i < _attributes.length; i++) {
  //     _attributes[i].value = 0;
  //   }
  // }

  @override
  void dispose() {
    _titleController.dispose();
    _directorController.dispose();
    _yearController.dispose();
    super.dispose();
  }
}
