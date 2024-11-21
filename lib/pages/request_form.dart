import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/current_user.dart';
import '../models/landlord.dart';
import '../models/roomie.dart';
import '../models/notification.dart';
import '../services/roomie_service.dart';
import 'package:http/http.dart' as http;

class RequestForm extends StatefulWidget {
  final int landlordId;
  final int postId;

  const RequestForm({
    super.key,
    required this.landlordId,
    required this.postId,
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
    _getUserInfo();
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

  Future<void> _getUserInfo() async {
    try {
      final response = await http.get(
        Uri.parse('https://easygoing-perception-production.up.railway.app/api/tenants/${CurrentUser().getId()}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final Tenant tenant = Tenant.fromJson(jsonDecode(response.body));
        setState(() {
          mainNameController.text = tenant.name;
          mainEmailController.text = tenant.email;
        });
      } else {
        throw Exception('Error al obtener datos del usuario');
      }
    } catch (e) {
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
                          List<int> tenantIds = [];

                          final responseTenants = await http.get(
                            Uri.parse('https://easygoing-perception-production.up.railway.app/api/tenants'),
                            headers: {
                              'Content-Type': 'application/json; charset=UTF-8',
                            },
                          );

                          if (responseTenants.statusCode == 200) {
                            List<Tenant> tenants = (jsonDecode(responseTenants.body) as List)
                                .map((tenant) => Tenant.fromJson(tenant))
                                .toList();
                            Tenant? mainTenant = tenants.firstWhere((tenant) => tenant.email == mainEmailController.text);
                            if (mainTenant != null) {
                              tenantIds.add(mainTenant.id);
                            } else {
                              const snackBar = SnackBar(
                                content: Text('Email principal no encontrado'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              return;
                            }

                            if (selectedValue != null && selectedValue! > 0) {
                              for (int i = 0; i < selectedValue!; i++) {
                                Tenant? additionalTenant = tenants.firstWhere((tenant) => tenant.email == emailControllers[i].text);
                                if (additionalTenant != null) {
                                  tenantIds.add(additionalTenant.id);
                                } else {
                                  const snackBar = SnackBar(
                                    content: Text('Email adicional no encontrado'),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  return;
                                }
                              }
                            }

                            final notification = {
                              "tenantIds": tenantIds,
                              "landlordId": widget.landlordId,
                              "postId": widget.postId,
                              "date": DateTime.now().toIso8601String()
                            };

                            final response = await http.post(
                              Uri.parse('https://easygoing-perception-production.up.railway.app/api/notifications'),
                              headers: {
                                'Content-Type': 'application/json; charset=UTF-8',
                              },
                              body: jsonEncode(notification),
                            );

                            print('StatusCode: ${response.statusCode}');
                            print('Body: ${response.body}');

                            if (response.statusCode == 200) {
                              const snackBar = SnackBar(
                                content: Text('Request sent'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              Navigator.pop(context);
                            } else {
                              const snackBar = SnackBar(
                                content: Text('Error al enviar solicitud'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          } else {
                            const snackBar = SnackBar(
                              content: Text('Error al obtener tenants'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        } catch (e) {
                          print('Error al enviar solicitud: $e');
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

