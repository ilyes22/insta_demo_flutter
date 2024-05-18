class Post {
  final String name;
  final String content;

  final String image;
  final String id;
  final bool isFavorite;

  Post(
      {required this.id,
      required this.image,
      required this.content,
      required this.name,
      this.isFavorite = false});

  Post copyWith(
      {String? name,
      String? img,
      String? content,
      String? id,
      bool? isFavorite}) {
    return Post(
        id: id ?? this.id,
        image: img ?? image,
        name: name ?? this.name,
        content: content ?? this.content,
        isFavorite: isFavorite ?? this.isFavorite);
  }
}
