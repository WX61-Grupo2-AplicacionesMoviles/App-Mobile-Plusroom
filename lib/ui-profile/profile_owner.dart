import 'package:flutter/material.dart';
import 'package:app_mobile_plusroom/shared/buttonApp.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileOwner extends StatefulWidget {
  final int landlordId;

  const ProfileOwner({super.key, required this.landlordId});
  static String id = 'profile_owner';

  @override
  _ProfileOwnerState createState() => _ProfileOwnerState();
}

class _ProfileOwnerState extends State<ProfileOwner> {
  Map<String, dynamic>? userProfile;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchUserProfile(widget.landlordId).then((data) {
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

  Future<Map<String, dynamic>> fetchUserProfile(int landlordId) async {
    final url = Uri.parse('https://easygoing-perception-production.up.railway.app/api/landlords/$landlordId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
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
                    (userProfile!['name'] ?? '') + ' ' + (userProfile!['lastName'] ?? ''),
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
                    cardInfo(context, userProfile!['name'] ?? '', 'Name'),
                    cardInfo(context, userProfile!['lastName'] ?? '', 'Last Name'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        cardInfo(context, userProfile!['age']?.toString() ?? '', 'Age'),
                        cardInfo(context, userProfile!['gender'] ?? '', 'Gender'),
                      ],
                    ),
                    cardInfo(context, userProfile!['email'] ?? '', 'Email'),
                    cardInfo(context, userProfile!['dni'] ?? '', 'DNI'),
                    cardInfo(context, userProfile!['description'] ?? '', 'Description'),
                    Container(
                      margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: FractionallySizedBox(
                        widthFactor: 0.5,
                        child: buttonApp(
                          "Edit Profile",
                              () {
                            // Add navigation to edit profile page if needed
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