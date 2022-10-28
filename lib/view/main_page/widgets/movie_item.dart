import 'package:flutter/material.dart';
import 'package:movie_recommender/constants/constant_assets.dart';
import 'package:movie_recommender/constants/constant_texts.dart';
import 'package:movie_recommender/constants/constant_typography.dart';
import 'package:movie_recommender/models/movie.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class MovieItem extends StatefulWidget {
  final Movie movie;

  const MovieItem({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  State<MovieItem> createState() => _MovieItemState();
}

class _MovieItemState extends State<MovieItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    String? image_url = widget.movie.poster_url;
    return GestureDetector(
      onTap: () {
        isExpanded = !isExpanded;
        if (mounted) setState(() {});
      },
      child: Card(
        child: Column(
          children: [
            // Always visible:
            Row(
              children: [
                image_url != null
                    ? OptimizedCacheImage(
                        imageUrl: image_url,
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
                      )
                    : Image.asset(
                        PLACEHOLDER,
                        width: 100,
                        height: 140,
                        fit: BoxFit.cover,
                      ),
                Container(
                  constraints:
                      const BoxConstraints(maxWidth: 250, minHeight: 140),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.movie.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: MOVIE_TITLE_STYLE,
                        ),
                        Text(
                          widget.movie.year.toString(),
                          style: MOVIE_HEADER_STYLE,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),

            // Visible after click:
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    _cell(DIRECTOR, widget.movie.director),
                    _cell(GENRE, widget.movie.genre),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _cell(String description, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(description, style: MOVIE_SUB_HEADER_STYLE),
          Text(value, style: MOVIE_HEADER_STYLE),
        ],
      ),
    );
  }
}
