import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_recommender/constants/assets.dart';
import 'package:movie_recommender/constants/colors.dart';
import 'package:movie_recommender/constants/genres.dart';
import 'package:movie_recommender/constants/movie_attributes.dart';
import 'package:movie_recommender/constants/texts.dart';
import 'package:movie_recommender/constants/typography.dart';
import 'package:movie_recommender/models/movie.dart';
import 'package:movie_recommender/models/movie_attribute.dart';
import 'package:movie_recommender/view/main_page/cubit/movies_cubit.dart';
import 'package:movie_recommender/view/main_page/widgets/attribute_item.dart';
import 'package:movie_recommender/view/widgets/input_field.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class MovieDialog extends StatefulWidget {
  final Movie? movie;

  const MovieDialog({
    Key? key,
    this.movie,
  }) : super(key: key);

  @override
  State<MovieDialog> createState() => _MovieDialogState();
}

class _MovieDialogState extends State<MovieDialog> {
  // Poster:
  final ImagePicker _picker = ImagePicker();
  XFile? _file;

  // Details:
  late final TextEditingController _titleController =
      TextEditingController(text: widget.movie?.title);
  late final TextEditingController _directorController =
      TextEditingController(text: widget.movie?.director);
  late final TextEditingController _yearController =
      TextEditingController(text: widget.movie?.year.toString());
  late String _selectedGenre = widget.movie?.genre ?? genres.first;

  // Stars:
  late final List<MovieAttribute> _attributes =
      widget.movie?.attributes ?? movie_attributes.toList();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.movie?.title != null ? EDIT_MOVIE : ADD_NEW_MOVIE,
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        width: 300,
        height: 600,
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _chooseImageFromGallery,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: _poster(),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: _editIcon(),
                    )
                  ],
                ),
              ),
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
                child: Text(
                  MOVIE_ATTRIBUTES,
                  style: CustomTypography.p3Medium,
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _attributes.length,
                itemBuilder: (_, index) {
                  return AttributeItem(
                    attribute: _attributes[index],
                    onRatingUpdate: (value) => _onRatingUpdate(value, index),
                  );
                },
              )
            ],
          ),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text(CANCEL),
        ),
        TextButton(
          onPressed: () async {
            MoviesCubit cubit = context.read<MoviesCubit>();
            cubit.addOrEditMovie(
              attributes: _attributes,
              currentId: widget.movie?.id,
              currentPosterUrl: widget.movie?.poster_url,
              director: _directorController.text,
              genre: _selectedGenre,
              posterFile: _file,
              title: _titleController.text,
              year: int.tryParse(_yearController.text),
            );
          },
          child: const Text(OK),
        ),
      ],
    );
  }

  Widget _poster() {
    if (_file != null) {
      return Image.file(
        File(_file!.path),
        height: 140,
        width: 100,
        fit: BoxFit.cover,
      );
    }

    String? poster = widget.movie?.poster_url;
    if (poster != null) {
      return OptimizedCacheImage(
        imageUrl: poster,
        height: 140,
        width: 100,
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
      );
    }

    return Image.asset(
      Assets.placeholder,
      height: 140,
      width: 100,
      fit: BoxFit.cover,
    );
  }

  Widget _editIcon() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.blue,
      ),
      width: 30.0,
      height: 30.0,
      child: const Icon(Icons.edit, color: Colors.white, size: 17.5),
    );
  }

  Widget _dropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: CustomColors.lightBlueOp,
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

  void _onRatingUpdate(double rating, int index) {
    _attributes[index] =
        _attributes[index].copyWith(value: (rating * 2).toInt());
  }

  Future<void> _chooseImageFromGallery() async {
    _file = await _picker.pickImage(source: ImageSource.gallery);
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    _directorController.dispose();
    _yearController.dispose();
    super.dispose();
  }
}
