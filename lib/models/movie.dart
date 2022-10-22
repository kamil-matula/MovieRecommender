class Movie {
  final String title;
  final String director;
  final String genre;
  final int year;
  final String? url;
  bool isExpanded = false;

  Movie(this.title, this.director, this.genre, this.year, this.url);
}
