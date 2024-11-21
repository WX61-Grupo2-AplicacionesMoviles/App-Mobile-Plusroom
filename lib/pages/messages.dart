import 'package:app_mobile_plusroom/pages/send_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/message_service.dart';

class MessagesList extends StatefulWidget {
  const MessagesList({super.key});

  @override
  _MessagesListState createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  late Future<List<dynamic>> _mensajesFuture;

  @override
  void initState() {
    super.initState();
    _mensajesFuture = getMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages Page"),
        actions: [
          IconButton(
            icon: Icon(Icons.mail),
            onPressed: () {},
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: _mensajesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final mensaje = snapshot.data![index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFF064789),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(mensaje['authorName'], style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),),
                            Spacer(),
                          ],
                        ),
                        Text(mensaje['content'], style: TextStyle(
                          color: Colors.white,
                        ),),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.lightBlue,
                              foregroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SendMessage(userId: mensaje['authorId'])),
                              );
                            },
                            child: Text("Reply"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error al obtener los mensajes');
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}