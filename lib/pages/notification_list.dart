import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/current_user.dart';

class NotificationList extends StatefulWidget {
  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  List<Notification> _notifications = [];
  bool _isLoading = false;

  String _formatDateTime(String dateTime) {
    DateTime date = DateTime.parse(dateTime);
    String formattedDate = '${date.day}-${date.month}-${date.year} ';
    String hour = date.hour >= 12 ? '${date.hour - 12}' : '${date.hour}';
    String minute = '${date.minute}';
    String ampm = date.hour >= 12 ? 'PM' : 'AM';
    return formattedDate + '$hour:$minute $ampm';
  }

  Future<List<String>> _getTenantNames(List<int> tenantIds) async {
    List<String> tenantNames = [];

    for (int tenantId in tenantIds) {
      final response = await http.get(
        Uri.parse('https://easygoing-perception-production.up.railway.app/api/tenants/$tenantId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        tenantNames.add(jsonData['name'] + ' ' + jsonData['lastName']);
      } else {
        tenantNames.add('Nombre no disponible');
      }
    }

    return tenantNames;
  }

  Future<String> _getPostTitle(int postId) async {
    final response = await http.get(
      Uri.parse('https://easygoing-perception-production.up.railway.app/api/posts/$postId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData['title'];
    } else {
      return 'Título no disponible';
    }
  }

  Future<void> _getNotifications() async {
    if (CurrentUser().getRole() != 'landlord') {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    final id = CurrentUser().getId();
    final role = CurrentUser().getRole();

    if (role == 'landlord') {
      final response = await http.get(
        Uri.parse('https://easygoing-perception-production.up.railway.app/api/landlords/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          _notifications = (jsonData['listNotification'] as List)
              .map((notification) => Notification.fromJson(notification))
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        print('Error al obtener notificaciones');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification Page"),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : CurrentUser().getRole() == 'landlord'
          ? ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          return FutureBuilder(
            future: Future.wait([
              _getTenantNames(_notifications[index].tenantIds),
              _getPostTitle(_notifications[index].postId),
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data![1] as String,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text('Rental application'),
                        SizedBox(height: 10),
                        Text('Date: ${_formatDateTime(_notifications[index].date)}'),
                        Text('Users:'),
                        Column(
                          children: (snapshot.data![0] as List<String>).map((tenantName) {
                            return Text(tenantName);
                          }).toList(),
                        ),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.lightGreen,
                                foregroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5))),
                                minimumSize: Size(100, 40),
                              ),
                              onPressed: () {},
                              child: Text("Aceptar"),
                            ),
                            SizedBox(width: 10),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.blue.shade900,
                                foregroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5))),
                                minimumSize: Size(100, 40),
                              ),
                              onPressed: () {},
                              child: Text("Rechazar"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Center(child: Text('Error al cargar datos'));
              }
            },
          );
        },
      )
      : Center(
        child: Text('No notifications available'),
      ),
    );
  }
}

class Notification {
  int id;
  List<int> tenantIds;
  int postId;
  String date;

  Notification({required this.id, required this.tenantIds, required this.postId, required this.date});

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      tenantIds: json['tenantIds'].cast<int>(),
      postId: json['postId'],
      date: json['date'],
    );
  }
}