import 'package:flutter/material.dart';
import 'package:movie_recommender/constants/constant_assets.dart';
import 'package:movie_recommender/models/movie.dart';
import 'package:movie_recommender/view/main_page/widgets/list_of_movies.dart';

// TODO: This is temporary list only
final List<Movie> temporaryMovies = [
  Movie(
    title: 'The Lord of the Rings: The Fellowship of the Ring',
    director: 'Peter Jackson',
    genre: 'Fantasy',
    year: 2001,
  ),
  Movie(
    title: 'The Lord of the Rings: The Two Towers',
    director: 'Peter Jackson',
    genre: 'Fantasy',
    year: 2002,
    url:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/640px-Image_created_with_a_mobile_phone.png',
  ),
  Movie(
    title: 'The Lord of the Rings: The Return of the King',
    director: 'Peter Jackson',
    genre: 'Fantasy',
    year: 2003,
  ),
];

// TODO: This is temporary list only
const List<String> genres = <String>['Action', 'Fantasy', 'Comedy', 'Drama'];

class AdminMovies extends StatelessWidget {
  final AppBar appBar;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController directorController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController genreController = TextEditingController();

  AdminMovies({Key? key, required this.appBar}) : super(key: key);

  Widget textField(
    String label,
    double width,
    TextEditingController textEditingController,
  ) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: textEditingController,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: ListOfMovies(movies: temporaryMovies),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  'Add new movie',
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
                      TextFormField(
                        controller: titleController,
                        decoration:
                            const InputDecoration(labelText: 'Movie title'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          textField('Director', 130, directorController),
                          textField('Year', 50, yearController),
                          textField('Genre', 70, genreController),
                        ],
                      )
                    ],
                  ),
                ),
                actionsAlignment: MainAxisAlignment.spaceAround,
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
