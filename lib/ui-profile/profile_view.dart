import 'package:flutter/material.dart';
import 'package:app_mobile_plusroom/shared/buttonApp.dart';
import 'package:app_mobile_plusroom/ui-profile/edit_profile_roomie.dart';
import 'package:app_mobile_plusroom/properties-searching/ui/post-ui/list_posts.dart';
import 'package:app_mobile_plusroom/pages/clients/ui/list_clients.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileView extends StatefulWidget {
  final int userId;

  const ProfileView({super.key, required this.userId});
  static String id = 'profile_view';

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Map<String, dynamic>? userProfile;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchUserProfile(widget.userId).then((data) {
      if (mounted) {
        setState(() {
          userProfile = data;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          errorMessage = error.toString();
        });
      }
    });
  }

  Future<Map<String, dynamic>> fetchUserProfile(int userId) async {
    final url = Uri.parse('https://easygoing-perception-production.up.railway.app/api/tenants/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else
    if (response.statusCode == 404) {
      throw Exception('Profile not found');
    } else {
      throw Exception('Error fetching profile data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: userProfile == null
            ? errorMessage != null
            ? Text(errorMessage!)
            : CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('lib/assets/img_profile.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    userProfile!['name'] + ' ' + userProfile!['lastName'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    cardInfo(context, userProfile!['name'], 'Name'),
                    cardInfo(context, userProfile!['lastName'], 'Last Name'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        cardInfo(context, userProfile!['age'].toString(), 'Age'),
                        cardInfo(context, userProfile!['gender'], 'Gender'),
                      ],
                    ),
                    cardInfo(context, userProfile!['email'], 'Email'),
                    cardInfo(context, userProfile!['dni'], 'DNI'),
                    cardInfo(context, userProfile!['description'], 'Description'),

                    // Botones Edit Profile, Posts, y Clients
                    Container(
                      margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: Column(
                        children: [
                          // Botón Edit Profile
                          FractionallySizedBox(
                            widthFactor: 0.5,
                            child: buttonApp(
                              "Edit Profile",
                                  () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfileRoomie(userId: widget.userId),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Botón Posts
                          FractionallySizedBox(
                            widthFactor: 0.5,
                            child: buttonApp(
                              "Posts",
                                  () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ListPosts(), // Navega a la lista de publicaciones
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Botón Clients
                          FractionallySizedBox(
                            widthFactor: 0.5,
                            child: buttonApp(
                              "Clients",
                                  () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ListClients(),
                                  ),
                                );
                              },
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardInfo(BuildContext context, String info, String placeholder) {
    final size = MediaQuery.of(context).size;

    return Card(
      color: const Color(0xFFD9D9D9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.1,
          vertical: 15,
        ),
        child: Center(
          child: Text(
            info.isNotEmpty ? info : placeholder,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: info.isNotEmpty ? Color.fromARGB(255, 12, 11, 11) : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
