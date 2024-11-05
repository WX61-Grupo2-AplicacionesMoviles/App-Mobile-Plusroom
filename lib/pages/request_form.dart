import 'package:flutter/material.dart';

class RequestForm extends StatefulWidget {
  const RequestForm({super.key});

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  int? selectedValue;

  // main controller for text field -> name
  final TextEditingController mainNameController = TextEditingController();
  final TextEditingController mainEmailController = TextEditingController();

  List<int> list = <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

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
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email ${i + 1}',
                          ),
                        ),
                      ),

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
                      onPressed: () {
                        const snackBar = SnackBar(
                          content: Text('Request sent'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.pop(context);
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

