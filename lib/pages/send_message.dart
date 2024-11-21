import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/current_user.dart';


class SendMessage extends StatefulWidget {
  final int? userId;

  const SendMessage({super.key, this.userId});

  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _description = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchEmail();
  }

  Future<void> _fetchEmail() async {
    final url = Uri.parse('https://easygoing-perception-production.up.railway.app/api/landlords/${widget.userId}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        _email = jsonData['email'];
      });
    } else {
      print('Error al obtener el email');
    }
  }

  Future<void> _sendMessage() async {
    final url = Uri.parse('https://easygoing-perception-production.up.railway.app/messages');
    final currentUser = CurrentUser().getId();
    final body = {
      'authorId': currentUser,
      'recipientId': widget.userId,
      'content': _description,
    };

    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Mensaje enviado con éxito');
      Navigator.pop(context);
    } else {
      print('Error al enviar el mensaje');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enviar mensaje"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: TextEditingController(text: _email),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Recipient email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter a message";
                  }
                  return null;
                },
                onSaved: (value) => _description = value!,
              ),
              SizedBox(height: 16),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _sendMessage();
                  }
                },
                child: Text("Send"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}