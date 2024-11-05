import 'dart:convert';
import 'package:app_mobile_plusroom/models/roomie.dart';
import 'package:http/http.dart' as http;

class RoomieService {

  // base url
  final String apiUrl = "https://giving-perception-production.up.railway.app/api";


  // get all roomies
  Future<List<Tenant>> getRoomies() async {
    final response = await http.get(Uri.parse("$apiUrl/tenants"));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((roomie) => Tenant.fromJson(roomie)).toList();
    } else {
      throw Exception('Error to get roomies data');
    }
  }

}
