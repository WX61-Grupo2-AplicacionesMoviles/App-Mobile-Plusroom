import 'Post.dart';

class Landlord {
  final int id;
  final String name;
  final String lastName;
  final String email;
  final String description;
  final int age;
  final String gender;
  final List<Post> posts;
  final List<int> customers;
  double rating;
  final String photo;

  Landlord({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    required this.description,
    required this.age,
    required this.gender,
    required this.posts,
    required this.customers,
    required this.rating,
    required this.photo,
  });

  factory Landlord.fromJson(Map<String, dynamic> json) {
    return Landlord(
      id: json['id'] as int? ?? 0,
      name: json['name'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      description: json['description'] ?? '',
      age: json['age'] as int? ?? 0,
      gender: json['gender'] ?? '',
      posts: json['posts'] != null
          ? json['posts'].map((post) => Post.fromJson(post)).toList().cast<Post>()
          : [],
      customers: json['customers'] != null
          ? List<int>.from(json['customers']) ?? []
          : [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      photo: json['photo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'email': email,
      'description': description,
      'age': age,
      'gender': gender,
      'posts': posts.map((post) => post.toJson()).toList(),
      'customers': customers,
      'rating': rating,
      'photo': photo,
    };
  }
}