import 'dart:convert';
import '../../models/Post.dart';
import 'package:http/http.dart' as http;

class PostService {
  final String apiUrl;

  PostService() : apiUrl = 'https://giving-perception-production.up.railway.app/api/posts';

  Future<List<Post>> getPosts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {

      final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
      return jsonData.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load posts");
    }
  }
}
