// lib/ui-profile/profile_view.dart
import 'package:flutter/material.dart';
import 'package:app_mobile_plusroom/shared/buttonApp.dart';
import 'package:app_mobile_plusroom/ui-profile/edit_profile_roomie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileView extends StatefulWidget {
  final int tenantId;

  const ProfileView({super.key, required this.tenantId});
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
    fetchUserProfile(widget.tenantId).then((data) {
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

  Future<Map<String, dynamic>> fetchUserProfile(int tenantId) async {
    final userUrl = Uri.parse('https://easygoing-perception-production.up.railway.app/api/tenants/$tenantId');
    final preferencesUrl = Uri.parse('https://easygoing-perception-production.up.railway.app/api/roomies/search/preferences?tenantId=$tenantId');

    final userResponse = await http.get(userUrl);
    final preferencesResponse = await http.get(preferencesUrl);

    if (userResponse.statusCode == 200 && preferencesResponse.statusCode == 200) {
      final userData = jsonDecode(userResponse.body);
      final preferencesData = jsonDecode(preferencesResponse.body);

      return {
        ...userData,
        'petFriendly': preferencesData['petFriendly'],
        'smokingPreference': preferencesData['smokingPreference'],
      };
    } else {
      throw Exception('Error fetching profile data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
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
                      if (userProfile!['petFriendly'] == true)
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0, left: 20.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.pets),
                              SizedBox(width: 8),
                              Text(
                                'Con mascotas',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (userProfile!['smokingPreference'] == true)
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0, left: 20.0, bottom: 15.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.smoking_rooms),
                              SizedBox(width: 8),
                              Text(
                                'Fuma',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Container(
                        margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child: FractionallySizedBox(
                          widthFactor: 0.5,
                          child: buttonApp(
                            "Edit Profile",
                                () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfileRoomie(tenantId: widget.tenantId),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const FractionallySizedBox(
                        widthFactor: 0.5,
                      ),
                      const SizedBox(height: 5),
                      const FractionallySizedBox(
                        widthFactor: 0.5,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget infoText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 20.0, bottom: 15.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}