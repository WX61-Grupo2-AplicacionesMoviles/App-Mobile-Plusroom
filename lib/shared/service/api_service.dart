// lib/shared/service/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<http.Response> registerLandlord(String name, String lastName, String email, String password, String description, int age, String gender, String photo) async {
    final url = Uri.parse('$baseUrl/landlord-controller/createLandlord');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'lastName': lastName,
        'email': email,
        'password': password,
        'description': description,
        'age': age,
        'gender': gender,
        'photo': photo,
      }),
    );
    return response;
  }
}