import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_recommender/constants/constant_assets.dart';
import 'package:movie_recommender/constants/constant_texts.dart';
import 'package:movie_recommender/constants/constant_typography.dart';
import 'package:movie_recommender/models/movie.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class MovieItem extends StatefulWidget {
  final Movie movie;

  const MovieItem({Key? key, required this.movie}) : super(key: key);

  @override
  State<MovieItem> createState() => _MovieItemState();
}

class _MovieItemState extends State<MovieItem> {
  bool isExpanded = false;

  Widget cell(String description, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(description, style: MOVIE_SUB_HEADER),
          Text(value, style: MOVIE_HEADER),
        ],
      ),
    );
  }

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
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : Image.asset(
                        PLACEHOLDER,
                        width: 140,
                        height: 140,
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
                          style: MOVIE_TITLE,
                        ),
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
                    cell(DIRECTOR, widget.movie.director),
                    cell(GENRE, widget.movie.genre),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
