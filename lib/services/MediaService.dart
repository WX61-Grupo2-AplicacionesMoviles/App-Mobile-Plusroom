import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class MediaService {
  final String baseUrl = 'https://easygoing-perception-production.up.railway.app/api'; // Cambia con tu URL base

  Future<String> uploadImage(File imageFile, int postId) async {
    final String uploadUrl = '$baseUrl/media/post/$postId/upload';

    final request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
    request.files.add(
      await http.MultipartFile.fromPath('files', imageFile.path),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final Map<String, dynamic> data = jsonDecode(responseBody);
      return data['urlPhoto'] ?? ''; // Devuelve la URL de la imagen
    } else {
      throw Exception('Error al subir la imagen: ${response.statusCode}');
    }
  }
}
