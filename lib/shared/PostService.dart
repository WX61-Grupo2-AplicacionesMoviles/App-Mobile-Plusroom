import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/Post.dart';

class PostService {
  final String apiUrl;

  PostService() : apiUrl = 'https://easygoing-perception-production.up.railway.app/api/posts';

  // Método para obtener todas las publicaciones
  Future<List<Post>> getPosts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
        return jsonData.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception("Error ${response.statusCode}: No se pudieron cargar las publicaciones");
      }
    } catch (e) {
      throw Exception("Error de red: $e");
    }
  }

  // Método para crear una nueva publicación
  Future<void> createPost(Post post) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'title': post.title,
          'description': post.description,
          'location': post.location,
          'price': post.price,
          'category': post.category,
          'urlPhoto': post.urlPhoto,
          'available': post.available,
          'rooms': post.rooms,
          'bathrooms': post.bathrooms,
          'pets': post.pets,
          'smoking': post.smoking,
          'landlordId': post.landlordId
        }),
      );

      if (response.statusCode != 201) {
        print("Error al crear publicación. Código: ${response.statusCode}");
        print("Cuerpo de la respuesta: ${response.body}");
        throw Exception("Error ${response.statusCode}: No se pudo crear la publicación. ${response.body}");
      }
    } catch (e) {
      throw Exception("Error de red: $e");
    }
  }

  // Método para actualizar una publicación existente
  Future<void> updatePost(Post post) async {
    final response = await http.put(
      Uri.parse(apiUrl), // La URL base, sin el ID
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': post.id, // Asegúrate de incluir el ID en el cuerpo
        'title': post.title,
        'description': post.description,
        'location': post.location,
        'price': post.price,
        'category': post.category,
        'urlPhoto': post.urlPhoto,
        'available': post.available,
        'rooms': post.rooms,
        'bathrooms': post.bathrooms,
        'pets': post.pets,
        'smoking': post.smoking,
        'landlordId': post.landlordId,
      }),
    );

    if (response.statusCode != 200) {
      print("Error al actualizar publicación. Código: ${response.statusCode}");
      print("Cuerpo de la respuesta: ${response.body}");
      throw Exception("Error ${response.statusCode}: No se pudo actualizar la publicación");
    }
  }

  // Método para eliminar una publicación
  Future<void> deletePost(int postId) async {
    final response = await http.delete(Uri.parse('$apiUrl/$postId'));

    if (response.statusCode != 200) {
      print("Error al eliminar publicación. Código: ${response.statusCode}");
      print("Cuerpo de la respuesta: ${response.body}");
      throw Exception("Error ${response.statusCode}: No se pudo eliminar la publicación");
    }
  }
}
