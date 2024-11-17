import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../components/text_item.dart';
import '../models/Post.dart';
import 'author_profile.dart';
import 'request_form.dart';

class PostDetail extends StatefulWidget {
  final Post post;

  const PostDetail({
    super.key,
    required this.post,
  });

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  LatLng? locationCoordinates;
  bool isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _getCoordinatesFromAddress(widget.post.location);
  }

  // Obtener coordenadas de una dirección
  Future<void> _getCoordinatesFromAddress(String address) async {
    final String apiKey = '0fcfb89709d84418b0e9d8cc96f07dfc'; //API de OpenCageData
    final String url =
        'https://api.opencagedata.com/geocode/v1/json?q=$address&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final geometry = data['results'][0]['geometry'];
        setState(() {
          locationCoordinates = LatLng(geometry['lat'], geometry['lng']);
          isLoadingLocation = false;
        });
      } else {
        print('Error en la geocodificación: ${response.body}');
        setState(() {
          isLoadingLocation = false;
        });
      }
    } catch (e) {
      print('Error al obtener coordenadas: $e');
      setState(() {
        isLoadingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Detail"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // post image
            Container(
              margin: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.post.urlPhoto,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // button landlord profile
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.lightBlue.shade100,
                foregroundColor: Colors.black,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                minimumSize: Size(180, 40),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AuthorProfile(landlordId: widget.post.landlordId),
                  ),
                );
              },
              child: Text("Go to Landlord profile"),
            ),

            // button request
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                minimumSize: Size(180, 40),
              ),
              onPressed: () {
                try {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RequestForm(landlordId: widget.post.landlordId),
                    ),
                  );
                } catch (error) {
                  print('Error al navegar: $error');
                }
              },
              child: Text("Request"),
            ),

            // card post details
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15.0),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade900,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextItem(
                      title: "Title",
                      titleSize: 18,
                      text: widget.post.title,
                      textSize: 16),
                  TextItem(
                      title: "Description",
                      titleSize: 18,
                      text: widget.post.description,
                      textSize: 16),
                  TextItem(
                    title: "Characteristics",
                    titleSize: 18,
                    text:
                    '${widget.post.rooms} rooms, ${widget.post.bathrooms} bathrooms, ${widget.post.pets ? 'pet friendly' : 'no pets'}, ${widget.post.smoking ? 'allow smoking' : 'no smoking'}',
                    textSize: 16,
                  ),
                  TextItem(
                      title: "Location",
                      titleSize: 18,
                      text: widget.post.location,
                      textSize: 16),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Price: ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(
                            text: '\$${widget.post.price}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Mapa
            Container(
              height: 300,
              margin: const EdgeInsets.all(10),
              child: isLoadingLocation
                  ? Center(child: CircularProgressIndicator())
                  : locationCoordinates != null
                  ? FlutterMap(
                options: MapOptions(
                  center: locationCoordinates,
                  zoom: 13.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: locationCoordinates!,
                        width: 80.0,
                        height: 80.0,
                        builder: (ctx) => Icon(
                          Icons.location_pin,
                          size: 40,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              )
                  : Center(
                child: Text(
                  'No se pudo cargar la ubicación',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
