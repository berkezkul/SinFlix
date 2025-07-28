class Movie {
  final String id;
  final String title;
  final String description;
  final String posterUrl;
  final bool isFavorite;
  
  // API'den gelen ek detaylar
  final String year;
  final String rated;
  final String released;
  final String runtime;
  final String genre;
  final String director;
  final String writer;
  final String actors;
  final String language;
  final String country;
  final String awards;
  final String metascore;
  final String imdbRating;
  final String imdbVotes;
  final String imdbID;

  Movie({
    required this.id,
    required this.title,
    this.description = '',
    this.posterUrl = '',
    this.isFavorite = false,
    this.year = '',
    this.rated = '',
    this.released = '',
    this.runtime = '',
    this.genre = '',
    this.director = '',
    this.writer = '',
    this.actors = '',
    this.language = '',
    this.country = '',
    this.awards = '',
    this.metascore = '',
    this.imdbRating = '',
    this.imdbVotes = '',
    this.imdbID = '',
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    String posterUrl = json['posterUrl'] ?? json['Poster'] ?? '';
    if (posterUrl.startsWith('http://')) {
      posterUrl = posterUrl.replaceFirst('http://', 'https://');
    }
    
    return Movie(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? json['Title']?.toString() ?? '',
      description: json['description']?.toString() ?? json['Plot']?.toString() ?? '',
      posterUrl: posterUrl,
      isFavorite: json['isFavorite'] ?? false,
      year: json['Year']?.toString() ?? '',
      rated: json['Rated']?.toString() ?? '',
      released: json['Released']?.toString() ?? '',
      runtime: json['Runtime']?.toString() ?? '',
      genre: json['Genre']?.toString() ?? '',
      director: json['Director']?.toString() ?? '',
      writer: json['Writer']?.toString() ?? '',
      actors: json['Actors']?.toString() ?? '',
      language: json['Language']?.toString() ?? '',
      country: json['Country']?.toString() ?? '',
      awards: json['Awards']?.toString() ?? '',
      metascore: json['Metascore']?.toString() ?? '',
      imdbRating: json['imdbRating']?.toString() ?? '',
      imdbVotes: json['imdbVotes']?.toString() ?? '',
      imdbID: json['imdbID']?.toString() ?? '',
    );
  }

  Movie copyWith({
    String? id,
    String? title,
    String? description,
    String? posterUrl,
    bool? isFavorite,
    String? year,
    String? rated,
    String? released,
    String? runtime,
    String? genre,
    String? director,
    String? writer,
    String? actors,
    String? language,
    String? country,
    String? awards,
    String? metascore,
    String? imdbRating,
    String? imdbVotes,
    String? imdbID,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      posterUrl: posterUrl ?? this.posterUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      year: year ?? this.year,
      rated: rated ?? this.rated,
      released: released ?? this.released,
      runtime: runtime ?? this.runtime,
      genre: genre ?? this.genre,
      director: director ?? this.director,
      writer: writer ?? this.writer,
      actors: actors ?? this.actors,
      language: language ?? this.language,
      country: country ?? this.country,
      awards: awards ?? this.awards,
      metascore: metascore ?? this.metascore,
      imdbRating: imdbRating ?? this.imdbRating,
      imdbVotes: imdbVotes ?? this.imdbVotes,
      imdbID: imdbID ?? this.imdbID,
    );
  }
}
