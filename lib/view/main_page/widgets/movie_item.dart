import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_recommender/constants/constant_assets.dart';
import 'package:movie_recommender/constants/constant_texts.dart';
import 'package:movie_recommender/constants/constant_typography.dart';
import 'package:movie_recommender/models/movie.dart';
import 'package:movie_recommender/view/movie_dialog/movie_dialog.dart';
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
                  width: 260,
                  constraints: const BoxConstraints(minHeight: 140),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.movie.year.toString(),
                              style: MOVIE_HEADER_STYLE,
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: const Color(0x4D3589EC),
                                textStyle: const TextStyle(fontSize: 20),
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(10),
                              ),
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (_) =>
                                      MovieDialog(movie: widget.movie),
                                );
                              },
                              child: const Icon(Icons.edit),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  // padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                  alignment: Alignment.topRight,
                  constraints:
                      const BoxConstraints(maxWidth: 40, minHeight: 140),
                  child: Column(
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          shape: const CircleBorder(),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () async {
                          FirebaseFirestore.instance
                              .collection('movies')
                              .doc(widget.movie.id)
                              .delete();
                        },
                        child:
                            const Icon(Icons.cancel, color: Color(0xFFD32F2F)),
                      ),
                    ],
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
