import 'package:flutter/material.dart';
import 'package:app_mobile_plusroom/services/roomie_service.dart';
import 'package:app_mobile_plusroom/models/roomie.dart';
import 'package:app_mobile_plusroom/pages/clients/ui/client_detail_page.dart';

class ListClients extends StatefulWidget {
  static const id = 'ListClients';

  @override
  _ListClientsState createState() => _ListClientsState();
}

class _ListClientsState extends State<ListClients> {
  final RoomieService _roomieService = RoomieService();
  late Future<List<Tenant>> _clientsFuture;

  @override
  void initState() {
    super.initState();
    _clientsFuture = _roomieService.getRoomies();
  }

  Future<void> _refreshClients() async {
    setState(() {
      _clientsFuture = _roomieService.getRoomies();
    });
    await _clientsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clients'),
      ),
      body: FutureBuilder<List<Tenant>>(
        future: _clientsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading clients: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No clients available.'));
          } else {
            return RefreshIndicator(
              onRefresh: _refreshClients,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final client = snapshot.data![index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF064789), // Fondo color #064789
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              client.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8), // Bordes menos redondeados
                                color: Colors.white, // Color de fondo en caso de error al cargar la imagen
                              ),
                              child: client.photo.trim().isNotEmpty
                                  ? Image.network(client.photo, fit: BoxFit.cover)
                                  : Icon(Icons.person, size: 40, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                client.occupation,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ClientDetailPage(client: client),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF002C3E), // Fondo color #002C3E
                                    foregroundColor: Colors.white, // Texto blanco
                                    minimumSize: Size(double.infinity, 36), // Ocupa el ancho disponible
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5), // Borde menos redondeado
                                    ),
                                  ),
                                  child: Text("Más información"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
