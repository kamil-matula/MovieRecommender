import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_recommender/constants/constant_assets.dart';
import 'package:movie_recommender/constants/constant_colors.dart';
import 'package:movie_recommender/constants/constant_texts.dart';
import 'package:movie_recommender/constants/constant_typography.dart';
import 'package:movie_recommender/models/movie.dart';
import 'package:movie_recommender/view/main_page/widgets/attribute_item.dart';
import 'package:movie_recommender/view/movie_dialog/movie_dialog.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class MovieItem extends StatefulWidget {
  final Movie movie;
  final bool isAdmin;

  const MovieItem({
    Key? key,
    required this.movie,
    required this.isAdmin,
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
                Expanded(
                  child: Container(
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
                          Text(
                            widget.movie.year.toString(),
                            style: MOVIE_HEADER_STYLE,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (widget.isAdmin)
                  Container(
                    width: 40,
                    constraints: const BoxConstraints(minHeight: 140),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.cancel,
                            color: DELETE_COLOR,
                          ),
                          onPressed: () async {
                            FirebaseFirestore.instance
                                .collection('movies')
                                .doc(widget.movie.id)
                                .delete();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 5.0,
                            right: 5.0,
                          ),
                          child: Ink(
                            width: 34,
                            decoration: const ShapeDecoration(
                              color: FORM_BACKGROUND_COLOR,
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.black,
                                size: 22,
                              ),
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (_) =>
                                      MovieDialog(movie: widget.movie),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            // Visible after click:
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _cell(DIRECTOR, widget.movie.director),
                        _cell(GENRE, widget.movie.genre),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(MOVIE_ATTRIBUTES, style: MOVIE_HEADER_STYLE),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.movie.attributes.length,
                      itemBuilder: (_, index) {
                        return AttributeItem(
                          attribute: widget.movie.attributes[index],
                          ignoreGestures: true,
                        );
                      },
                    )
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
