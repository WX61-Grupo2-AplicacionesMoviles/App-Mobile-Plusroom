import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/current_user.dart';

Future<List<dynamic>> getMessages() async {
  final idUsuario = CurrentUser().getId();
  final url = Uri.parse('https://easygoing-perception-production.up.railway.app/messages/recipient/$idUsuario');

  final respuesta = await http.get(url);

  if (respuesta.statusCode == 200) {
    final jsonData = jsonDecode(respuesta.body);
    return jsonData;
  } else {
    throw Exception('Error al obtener los mensajes');
  }
}