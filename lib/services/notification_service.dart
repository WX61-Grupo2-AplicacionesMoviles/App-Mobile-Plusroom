import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/notification.dart';

class NotificationService {
  final String baseUrl = "https://easygoing-perception-production.up.railway.app/api";
  
  Future<Notification> createNotification(Notification notification) async {
    print('Sending notification: $notification');
    final response = await http.post(
      Uri.parse('$baseUrl/notifications'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(notification.toJson()),
    );

    if (response.statusCode == 201) {
      return Notification.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create notification');
    }
  }

  Future<List<dynamic>> getNotifications() async {
    final url = Uri.parse('$baseUrl/notifications');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load notifications');
    }
  }
}
