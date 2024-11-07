import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/landlord.dart';
import '../models/roomie.dart';
import '../models/notification.dart';
import '../services/roomie_service.dart';
import 'package:http/http.dart' as http;

class RequestForm extends StatefulWidget {
  final int landlordId;

  const RequestForm({
    super.key,
    required this.landlordId,
  });

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  int? selectedValue;
  Landlord? _landlord;
  final RoomieService _roomieService = RoomieService();
  // main controller for text field -> name
  final TextEditingController mainNameController = TextEditingController();
  final TextEditingController mainEmailController = TextEditingController();
  List<TextEditingController> emailControllers = [];

  List<int> list = <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  @override
  void initState() {
    super.initState();
    _getLandlord();
  }

  Future<void> _getLandlord() async {
    final response = await http.get(
      Uri.parse('https://easygoing-perception-production.up.railway.app/api/landlords/${widget.landlordId}'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _landlord = Landlord.fromJson(jsonDecode(response.body));
      });
    } else {
      throw Exception('Error al obtener datos del landlord');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rent Request"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // request form
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your information:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 20),

                  // name & email text field
                  TextField(
                    controller: mainNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                  ),

                  SizedBox(height: 20),

                  TextField(
                    controller: mainEmailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),

                  SizedBox(height: 20),

                  // select number of people
                  Row(
                    children: [
                      Text(
                        "Add number of people:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 15),
                      DropdownMenu(
                        menuHeight: 150,
                        hintText: '0',
                        onSelected: (int? value) {
                          setState(() {
                            selectedValue = value;
                            emailControllers = List<TextEditingController>.generate(value!, (_) => TextEditingController());
                          });
                        },
                        dropdownMenuEntries:
                        list.map<DropdownMenuEntry<int>>((int value) {
                          return DropdownMenuEntry<int>(
                            value: value,
                            label: value.toString(),
                          );
                        }).toList(),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // create textfield email input -> number of people
                    if (selectedValue != null && selectedValue! > 0)
                      for (int i = 0; i < selectedValue!; i++)
                      Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: TextField(
                          controller: emailControllers.length <= i ? TextEditingController() : emailControllers[i],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email ${i + 1}',
                          ),
                  ),),

                  SizedBox(height: 20),

                  // send request button
                  Center(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        minimumSize: Size(150, 40),
                      ),
                      onPressed: () async {
                        List<Tenant> tenants = [];
                        // Verificar que los campos estén llenos
                        if (mainNameController.text.isEmpty ||
                            mainEmailController.text.isEmpty ||
                            (selectedValue != null && selectedValue! > 0 &&
                                emailControllers.any((controller) => controller.text.isEmpty))) {
                          const snackBar = SnackBar(
                            content: Text('Por favor, complete todos los campos'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }

                        try {
                          // Obtener la lista de roomies
                          final List<Tenant> roomies = await _roomieService.getRoomies();

                          // Busca el tenant principal
                          Tenant? mainTenant = roomies.firstWhere((tenant) => tenant.email == mainEmailController.text);
                          if (mainTenant != null) {
                            tenants.add(mainTenant);
                          }

                          // Busca los tenants adicionales
                          if (selectedValue != null && selectedValue! > 0) {
                            for (int i = 0; i < selectedValue!; i++) {
                              Tenant? tenant = roomies.firstWhere((tenant) => tenant.email == emailControllers[i].text);
                              if (tenant != null) {
                                tenants.add(tenant);
                              }
                            }
                          }

                      RentNotification notification = RentNotification(
                        id: 0,
                        tenants: tenants,
                        landlord: _landlord!,
                        postId: 0,
                        date: DateTime.now(),
                      );

/*
                          final response = await http.post(
                            Uri.parse('https://easygoing-perception-production.up.railway.app/api/notifications'),
                            headers: {
                              'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body: jsonEncode(notification.toJson()),
                          );
                          print('Respuesta del servidor: ${response.statusCode} ${response.body}');

                          if (response.statusCode == 200) {
                            // Solicitud exitosa
                            print('ta bien');
                          } else {
                            // Error en la solicitud
                            print('Error: ${response.statusCode} ${response.reasonPhrase}');
                          }
*/
                          const snackBar = SnackBar(
                            content: Text('Request sent'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.pop(context);
                        } catch (e) {
                          const snackBar = SnackBar(
                            content: Text('Error al enviar solicitud'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: Text("Send"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

