import 'package:flutter/material.dart';
import 'package:movie_recommender/constants/constant_assets.dart';
import 'package:movie_recommender/constants/constant_texts.dart';
import 'package:movie_recommender/constants/constant_typography.dart';
import 'package:movie_recommender/models/movie.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class ListOfMovies extends StatelessWidget {
  final List<Movie> movies;

  const ListOfMovies({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (BuildContext context, int index) {
        return MovieItem(movie: movies[index]);
      },
    );
  }
}

class MovieItem extends StatefulWidget {
  const MovieItem({Key? key, required this.movie}) : super(key: key);

  final Movie movie;

  @override
  State<MovieItem> createState() => _MovieItemState();
}

class _MovieItemState extends State<MovieItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    String? image_url = widget.movie.url;
    return GestureDetector(
      onTap: () => setState(() {
        isExpanded = !isExpanded;
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
                        PLACEHOLDER,
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
                          widget.movie.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: MOVIE_TITLE,
                        ),
                        const SizedBox(height: 40),
                        Text(
                          widget.movie.year.toString(),
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
                          const Text(DIRECTOR, style: MOVIE_SUB_HEADER),
                          Text(
                            widget.movie.director,
                            style: MOVIE_HEADER,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(GENRE, style: MOVIE_SUB_HEADER),
                          Text(
                            widget.movie.genre,
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
  }
}
