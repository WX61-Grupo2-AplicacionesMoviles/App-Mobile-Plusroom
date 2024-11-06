import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_mobile_plusroom/shared/buttonApp.dart';
import 'package:app_mobile_plusroom/router/routes.dart';

class EditProfileRoomie extends StatefulWidget {
  final int tenantId;

  const EditProfileRoomie({super.key, required this.tenantId});
  static String id = 'edit_profile_roomie';

  @override
  _EditProfileRoomieState createState() => _EditProfileRoomieState();
}

class _EditProfileRoomieState extends State<EditProfileRoomie> {
  bool _searchRoomie = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _photoController = TextEditingController();
  final TextEditingController _preferencesController = TextEditingController();
  final TextEditingController _hobbiesController = TextEditingController();
  final TextEditingController _locationPreferenceController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _genderPreferenceController = TextEditingController();
  final TextEditingController _minAgeController = TextEditingController();
  final TextEditingController _maxAgeController = TextEditingController();
  final TextEditingController _cleaningHabitsController = TextEditingController();
  final TextEditingController _sleepingHabitsController = TextEditingController();
  bool _petFriendly = false;
  bool _smokingPreference = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final String tenantId = widget.tenantId.toString();
    final String userUrl = 'https://easygoing-perception-production.up.railway.app/api/tenants/$tenantId';
    final String preferencesUrl = 'https://easygoing-perception-production.up.railway.app/api/roomies/search/preferences?tenantId=$tenantId';

    try {
      final userResponse = await http.get(Uri.parse(userUrl));
      if (userResponse.statusCode == 200) {
        final userData = jsonDecode(userResponse.body);
        setState(() {
          _nameController.text = userData['name'] ?? '';
          _lastNameController.text = userData['lastName'] ?? '';
          _emailController.text = userData['email'] ?? '';
          _descriptionController.text = userData['description'] ?? '';
          _dniController.text = userData['dni'] ?? '';
          _ageController.text = userData['age']?.toString() ?? '';
          _genderController.text = userData['gender'] ?? '';
          _occupationController.text = userData['occupation'] ?? '';
          _searchRoomie = userData['searchRoomie'] ?? false;
          _photoController.text = userData['photo'] ?? '';
        });
      } else {
        print('Error fetching user data: ${userResponse.statusCode}');
        print('Response body: ${userResponse.body}');
      }

      final preferencesResponse = await http.get(Uri.parse(preferencesUrl));
      if (preferencesResponse.statusCode == 200) {
        final preferencesData = jsonDecode(preferencesResponse.body);
        setState(() {
          _preferencesController.text = preferencesData['preferences']?.join(', ') ?? '';
          _hobbiesController.text = preferencesData['hobbies']?.join(', ') ?? '';
          _locationPreferenceController.text = preferencesData['locationPreference'] ?? '';
          _budgetController.text = preferencesData['budget']?.toString() ?? '';
          _genderPreferenceController.text = preferencesData['genderPreference'] ?? '';
          _minAgeController.text = preferencesData['minAge']?.toString() ?? '';
          _maxAgeController.text = preferencesData['maxAge']?.toString() ?? '';
          _petFriendly = preferencesData['petFriendly'] ?? false;
          _smokingPreference = preferencesData['smokingPreference'] ?? false;
          _cleaningHabitsController.text = preferencesData['cleaningHabits'] ?? '';
          _sleepingHabitsController.text = preferencesData['sleepingHabits'] ?? '';
        });
      } else {
        print('Error fetching preferences data: ${preferencesResponse.statusCode}');
        print('Response body: ${preferencesResponse.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching preferences data: ${preferencesResponse.statusCode}')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while fetching data')),
      );
    }
  }

  Future<void> _updateUserData() async {
    final String tenantId = widget.tenantId.toString();
    final response = await http.put(
      Uri.parse('https://easygoing-perception-production.up.railway.app/api/tenants/$tenantId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': _nameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
        'description': _descriptionController.text,
        'dni': _dniController.text,
        'age': int.parse(_ageController.text),
        'gender': _genderController.text,
        'occupation': _occupationController.text,
        'searchRoomie': _searchRoomie,
        'photo': _photoController.text,
      }),
    );

    if (response.statusCode == 200) {
      print('Datos del usuario actualizados correctamente');
    } else {
      print('Error al actualizar los datos del usuario: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> _saveRoomiePreferences() async {
    final String preferencesUrl = 'https://easygoing-perception-production.up.railway.app/api/roomies/preferences?tenantId=${widget.tenantId}';

    try {
      // First, try to update the preferences
      var response = await http.put(
        Uri.parse(preferencesUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'preferences': _preferencesController.text.split(', '),
          'hobbies': _hobbiesController.text.split(', '),
          'locationPreference': _locationPreferenceController.text,
          'budget': int.tryParse(_budgetController.text) ?? 0,
          'genderPreference': _genderPreferenceController.text,
          'minAge': int.tryParse(_minAgeController.text) ?? 0,
          'maxAge': int.tryParse(_maxAgeController.text) ?? 0,
          'petFriendly': _petFriendly,
          'smokingPreference': _smokingPreference,
          'cleaningHabits': _cleaningHabitsController.text,
          'sleepingHabits': _sleepingHabitsController.text,
        }),
      );

      // If the preferences do not exist, create them first
      if (response.statusCode == 404) {
        response = await http.post(
          Uri.parse(preferencesUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'preferences': [],
            'hobbies': [],
            'locationPreference': '',
            'budget': 0,
            'genderPreference': '',
            'minAge': 0,
            'maxAge': 0,
            'petFriendly': false,
            'smokingPreference': false,
            'cleaningHabits': '',
            'sleepingHabits': '',
          }),
        );

        // After creating, try to update again
        if (response.statusCode == 201) {
          response = await http.put(
            Uri.parse(preferencesUrl),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'preferences': _preferencesController.text.split(', '),
              'hobbies': _hobbiesController.text.split(', '),
              'locationPreference': _locationPreferenceController.text,
              'budget': int.tryParse(_budgetController.text) ?? 0,
              'genderPreference': _genderPreferenceController.text,
              'minAge': int.tryParse(_minAgeController.text) ?? 0,
              'maxAge': int.tryParse(_maxAgeController.text) ?? 0,
              'petFriendly': _petFriendly,
              'smokingPreference': _smokingPreference,
              'cleaningHabits': _cleaningHabitsController.text,
              'sleepingHabits': _sleepingHabitsController.text,
            }),
          );
        }
      }

      if (response.statusCode == 200) {
        print('Roomie preferences updated successfully');
      } else {
        print('Error updating roomie preferences: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
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
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('lib/assets/img_profile.png'),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                    ),
                    Text(
                      _nameController.text,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 239, 237, 237),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                        ),
                        TextField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(labelText: 'Last Name'),
                        ),
                        TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                        ),
                        TextField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(labelText: 'Description'),
                        ),
                        TextField(
                          controller: _dniController,
                          decoration: const InputDecoration(labelText: 'DNI'),
                        ),
                        TextField(
                          controller: _ageController,
                          decoration: const InputDecoration(labelText: 'Age'),
                        ),
                        TextField(
                          controller: _genderController,
                          decoration: const InputDecoration(labelText: 'Gender'),
                        ),
                        TextField(
                          controller: _occupationController,
                          decoration: const InputDecoration(labelText: 'Occupation'),
                        ),
                        TextField(
                          controller: _photoController,
                          decoration: const InputDecoration(labelText: 'Photo URL'),
                        ),
                        Row(
                          children: [
                            const Text(
                              '¿Buscas roomies?',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Checkbox(
                              value: _searchRoomie,
                              onChanged: (bool? value) {
                                setState(() {
                                  _searchRoomie = value ?? false;
                                });
                              },
                            ),
                          ],
                        ),
                        Visibility(
                          visible: _searchRoomie,
                          child: Column(
                            children: [
                              TextField(
                                controller: _locationPreferenceController,
                                decoration: const InputDecoration(labelText: 'Location Preference'),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.pets),
                                  SizedBox(width: 8),
                                  const Text('¿Tienes mascotas?'),
                                  Checkbox(
                                    value: _petFriendly,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _petFriendly = value ?? false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.smoking_rooms),
                                  SizedBox(width: 8),
                                  const Text('¿Fumas?'),
                                  Checkbox(
                                    value: _smokingPreference,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _smokingPreference = value ?? false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20.0),
                          child: FractionallySizedBox(
                            widthFactor: 0.5,
                            child: buttonApp(
                              "Save",
                                  () async {
                                await _updateUserData();
                                if (_searchRoomie) {
                                  await _saveRoomiePreferences();
                                }
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BottomNavBar(initialIndex: 4, tenantId: widget.tenantId),
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
      ),
    );
  }
}