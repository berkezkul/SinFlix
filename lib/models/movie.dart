class Movie {
  final String id;
  final String title;
  final String description;
  final String posterUrl;
  final bool isFavorite;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
    this.isFavorite = false,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    // HTTP posterlerini HTTPS'ye çevir
    String posterUrl = json['posterUrl'] ?? json['Poster'] ?? '';
    if (posterUrl.startsWith('http://')) {
      posterUrl = posterUrl.replaceFirst('http://', 'https://');
    }
    
    return Movie(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['title'] ?? json['Title'] ?? '', // Backend 'Title' kullanıyor
      description: json['description'] ?? json['Plot'] ?? '', // Backend 'Plot' kullanıyor
      posterUrl: posterUrl, // HTTPS'ye çevrilmiş URL
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'posterUrl': posterUrl,
      'isFavorite': isFavorite,
    };
  }

  Movie copyWith({
    String? id,
    String? title,
    String? description,
    String? posterUrl,
    bool? isFavorite,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      posterUrl: posterUrl ?? this.posterUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
