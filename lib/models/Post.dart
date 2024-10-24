class Post {
  final int id;
  final String title;
  final String description;
  final String location;
  final double price;
  final String category;
  final String urlPhoto;
  final bool available;
  final int rooms;
  final int bathrooms;
  final bool pets;
  final bool smoking;
  final int landlordId;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.price,
    required this.category,
    required this.urlPhoto,
    required this.available,
    required this.rooms,
    required this.bathrooms,
    required this.pets,
    required this.smoking,
    required this.landlordId,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int? ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] ?? '',
      urlPhoto: json['urlPhoto'] ?? '',
      available: json['available'] as bool? ?? false,
      rooms: json['rooms'] as int? ?? 0,
      bathrooms: json['bathrooms'] as int? ?? 0,
      pets: json['pets'] as bool? ?? false,
      smoking: json['smoking'] as bool? ?? false,
      landlordId: json['landlordId'] as int? ?? 0,
    );
  }
}
