import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_recommender/constants/constant_typography.dart';
import 'package:movie_recommender/models/movie.dart';

class ListOfMovies extends StatefulWidget {
  final List<Movie> movies;

  const ListOfMovies({
    Key? key,
    required this.movies,
  }) : super(key: key);

  @override
  State<ListOfMovies> createState() => _ListOfMoviesState();
}

class _ListOfMoviesState extends State<ListOfMovies> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.movies.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    color: Colors.grey,
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 250),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.movies[index].title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: MOVIE_TITLE,
                          ),
                          const SizedBox(height: 30),
                          Text(
                            widget.movies[index].year.toString(),
                            style: MOVIE_HEADER,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Row(),
            ],
          ),
        );
      },
    );
  }
}
