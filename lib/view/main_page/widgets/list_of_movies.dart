import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_recommender/constants/constant_typography.dart';
import 'package:movie_recommender/models/movie.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

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
        String? image_url = widget.movies[index].url;
        bool isExpanded = widget.movies[index].isExpanded;
        return GestureDetector(
          onTap: () => setState(() {
            widget.movies[index].isExpanded = !isExpanded;
          }),
          child: Card(
            child: Column(
              children: [
                // Always visible row:
                Row(
                  children: [
                    image_url != null
                        ? OptimizedCacheImage(
                            imageUrl: image_url,
                            width: 140,
                            height: 140,
                          )
                        : Image.asset(
                            'assets/images/placeholder.png',
                            width: 140,
                            height: 140,
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
                            const SizedBox(height: 40),
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
                // Visible after click
                if (isExpanded)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Director', style: MOVIE_SUB_HEADER),
                              Text(
                                widget.movies[index].director,
                                style: MOVIE_HEADER,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Genre', style: MOVIE_SUB_HEADER),
                              Text(
                                widget.movies[index].genre,
                                style: MOVIE_HEADER,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
