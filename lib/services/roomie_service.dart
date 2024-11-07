import 'dart:convert';
import 'package:app_mobile_plusroom/models/roomie.dart';
import 'package:http/http.dart' as http;

class RoomieService {

  // base url
  final String apiUrl = "https://easygoing-perception-production.up.railway.app/api";


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

  // get roomie preference by id
  Future<Preferences?> getRoomiePreferenceById(Tenant tenant) async {
    final response =
    await http.get(Uri.parse("$apiUrl/roomies/search/preferences?tenantId=${tenant.id}"));

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        dynamic jsonData = json.decode(utf8.decode(response.bodyBytes));
        return Preferences.fromJson(jsonData);
      } else {
        return null;
      }
    } else {
      throw Exception('Error to get roomie preference data');
    }
  }

}
