import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_recommender/constants/assets.dart';
import 'package:movie_recommender/constants/colors.dart';
import 'package:movie_recommender/constants/texts.dart';
import 'package:movie_recommender/constants/typography.dart';
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
                        Assets.placeholder,
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
                            style: CustomTypography.p2Semibold,
                          ),
                          Text(
                            widget.movie.year.toString(),
                            style: CustomTypography.p3Medium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (widget.isAdmin) _adminButtons(context),
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
                      child: Text(
                        MOVIE_ATTRIBUTES,
                        style: CustomTypography.p3Medium,
                      ),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.movie.attributes.length,
                      itemBuilder: (_, index) {
                        return AttributeItem(
                          attribute: widget.movie.attributes[index],
                          ignoreGestures: true,
                          onRatingUpdate: (_) {},
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
          Text(description, style: CustomTypography.p4MediumItalicGray),
          Text(value, style: CustomTypography.p3Medium),
        ],
      ),
    );
  }

  Widget _adminButtons(BuildContext context) {
    return Container(
      width: 55,
      constraints: const BoxConstraints(minHeight: 140),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _oneButton(
            color: CustomColors.bloodMoon,
            onTap: () async {
              FirebaseFirestore.instance
                  .collection('movies')
                  .doc(widget.movie.id)
                  .delete();
            },
            child: const Icon(Icons.close, color: Colors.white, size: 20),
          ),
          _oneButton(
            color: CustomColors.lightBlueOp,
            onTap: () async {
              showDialog(
                context: context,
                builder: (_) => MovieDialog(movie: widget.movie),
              );
            },
            child: const Icon(Icons.edit, color: Colors.black, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _oneButton({
    required Color color,
    required void Function() onTap,
    required Widget child,
  }) {
    return Material(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(20),
      color: color,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(5.0),
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: child,
        ),
      ),
    );
  }
}
