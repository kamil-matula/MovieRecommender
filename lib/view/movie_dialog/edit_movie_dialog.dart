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
import 'package:optimized_cached_image/optimized_cached_image.dart';

class EditMovieDialog extends StatefulWidget {

  final Movie movie;

  const EditMovieDialog({
    Key? key,
    required this.movie,
  }) : super(key: key);


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
  String selectedGenre = '';

  @override
  Widget build(BuildContext context) {
    _titleController.text = widget.movie.title;
    _directorController.text = widget.movie.director;
    _yearController.text = widget.movie.year.toString();
    if (selectedGenre == '') {
        selectedGenre = widget.movie.genre;
    }
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
    String? poster = widget.movie.url;
    return GestureDetector(
      onTap: _chooseImageFromGallery,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child:
            poster != null && _file == null
                ?  OptimizedCacheImage(
              imageUrl: poster,
              width: 100,
              height: 140,
              imageBuilder: (_, imageProvider) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ):
            _file != null
                ? Image.file(
              File(_file!.path),
              height: 140,
              width: 100,
              fit: BoxFit.cover,
            )
                : Image.asset(
              PLACEHOLDER,
              height: 140,
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
        child: DropdownButton(
          alignment: AlignmentDirectional.center,
          value: selectedGenre,
          items: genres.map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          ),).toList(),
          onChanged: (selectedItem) => setState(() {
            selectedGenre = selectedItem!;
          }),
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
    String id = widget.movie.id;
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
    if (_file != null) {
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref()
          .child('posters')
          .child('$id.jpg')
          .putFile(
        File(_file!.path),
        SettableMetadata(contentType: 'image/jpeg'),
      );
      url = await snapshot.ref.getDownloadURL();
    }

    // Prepare object:
    Movie movie = Movie(
      id: id,
      title: title,
      director: director,
      genre: selectedGenre,
      year: year,
      url: _file != null ? url : widget.movie.url,
    );

    // Update object in Firestore Database:
    FirebaseFirestore.instance
        .collection('movies')
        .doc(id)
        .update(movie.toJson());

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
