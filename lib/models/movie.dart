class Movie {
  final String title;
  final String director;
  final String genre;
  final int year;
  final String? url;

  Movie({
    required this.title,
    required this.director,
    required this.genre,
    required this.year,
    this.url,
  });
}
