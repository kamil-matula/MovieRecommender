class MovieAttributes {
  final int funny;
  final int scary;
  final int touching;
  final int romantic;
  final int adventures;
  final int criminal;
  final int musical;
  final int cartoon;
  final int historical;
  final int young_adult;

  MovieAttributes({
    required this.funny,
    required this.scary,
    required this.touching,
    required this.romantic,
    required this.adventures,
    required this.criminal,
    required this.musical,
    required this.cartoon,
    required this.historical,
    required this.young_adult,
  });

  Map<String, dynamic> toJson() {
    return {
      'funny': funny,
      'scary': scary,
      'touching': touching,
      'romantic': romantic,
      'adventures': adventures,
      'criminal': criminal,
      'musical': musical,
      'cartoon': cartoon,
      'historical': historical,
      'young_adult': young_adult,
    };
  }

  factory MovieAttributes.fromJson(Map<String, dynamic> map) {
    return MovieAttributes(
      funny: map['funny'] as int,
      scary: map['scary'] as int,
      touching: map['touching'] as int,
      romantic: map['romantic'] as int,
      adventures: map['adventures'] as int,
      criminal: map['criminal'] as int,
      musical: map['musical'] as int,
      cartoon: map['cartoon'] as int,
      historical: map['historical'] as int,
      young_adult: map['young_adult'] as int,
    );
  }
}
