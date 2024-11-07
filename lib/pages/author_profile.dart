import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import '../components/profile_image.dart';
import '../components/text_item.dart';
import '../models/landlord.dart';

class AuthorProfile extends StatelessWidget {
  final int landlordId;
  const AuthorProfile({super.key, required this.landlordId});


  Future<Landlord> _fetchLandlord() async {
    final response = await http.get(Uri.parse('https://easygoing-perception-production.up.railway.app/api/landlords/$landlordId'));

    if (response.statusCode == 200) {
      return Landlord.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load landlord');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Landlord Profile"),
      ),
      body: FutureBuilder<Landlord>(
        future: _fetchLandlord(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //  image
                  SizedBox(height: 20),
                  ProfileImage(
                    roomiePhoto: snapshot.data!.photo,
                    radius: 60.0,
                  ),

                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        // send message button
                        TextButton(
                          onPressed: () {},
                          child: Text("Send message"),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.lightBlue.shade100,
                            foregroundColor: Colors.black87,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5))),
                          ),
                        ),

                        SizedBox(height: 20),

                        // landlord information
                        Container(
                          width: double.infinity,
                          // full width
                          padding: const EdgeInsets.all(15.0),
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade900,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(child: Text("${snapshot.data!.name} ${snapshot.data!.lastName}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),)),

                              SizedBox(height: 15),

                              TextItem(
                                  title: "Landlord information",
                                  titleSize: 18,
                                  text: snapshot.data!.description,
                                  textSize: 16),
                              TextItem(
                                  title: "Email",
                                  titleSize: 18,
                                  text: snapshot.data!.email,
                                  textSize: 16),
                              TextItem(
                                  title: "Phone number",
                                  titleSize: 18,
                                  text: "No disponible", // Agrega el número de teléfono aquí
                                  textSize: 16),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),

                        Text(
                          "Rate this landlord:",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade900,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: RatingBar.builder(
                            initialRating: snapshot.data!.rating ?? 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}