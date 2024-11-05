import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_mobile_plusroom/shared/buttonApp.dart';
import 'package:app_mobile_plusroom/router/routes.dart';

class EditProfileRoomie extends StatefulWidget {
  final int userId;

  const EditProfileRoomie({super.key, required this.userId});
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

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final String userId = widget.userId.toString();
    final String url = 'https://easygoing-perception-production.up.railway.app/api/tenants/$userId';
    print('Fetching data from URL: $url');

    final response = await http.get(Uri.parse(url));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Parsed data: $data');
      setState(() {
        _nameController.text = data['name'] ?? '';
        _lastNameController.text = data['lastName'] ?? '';
        _emailController.text = data['email'] ?? '';
        _descriptionController.text = data['description'] ?? '';
        _dniController.text = data['dni'] ?? '';
        _ageController.text = data['age']?.toString() ?? '';
        _genderController.text = data['gender'] ?? '';
        _occupationController.text = data['occupation'] ?? '';
        _searchRoomie = data['searchRoomie'] ?? false;
        _photoController.text = data['photo'] ?? '';
      });
    } else {
      print('Error al cargar los datos del usuario: ${response.statusCode}');
    }
  }

  Future<void> _updateUserData() async {
    final String userId = widget.userId.toString();
    final response = await http.put(
      Uri.parse('https://easygoing-perception-production.up.railway.app/api/tenants/$userId'),
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
                        Container(
                          margin: const EdgeInsets.only(bottom: 20.0),
                          child: FractionallySizedBox(
                            widthFactor: 0.5,
                            child: buttonApp(
                              "Save",
                                  () async {
                                await _updateUserData();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BottomNavBar(initialIndex: 4, userId: widget.userId),
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