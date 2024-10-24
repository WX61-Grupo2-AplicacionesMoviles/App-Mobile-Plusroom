import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class YourPosts extends StatefulWidget {
  const YourPosts({super.key});
  static String id = 'posts_list';

  @override
  State<YourPosts> createState() => _YourPostsState();
}

class _YourPostsState extends State<YourPosts> {
  List<dynamic> _posts = [];

  @override
  void initState() {
    super.initState();
    loadPosts(); // Cargar los datos del archivo JSON
  }

  Future<void> loadPosts() async {
    // Cargar el archivo JSON desde los assets
    final String response = await rootBundle.loadString('assets/dbp.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      _posts = data; // Almacena las publicaciones en la lista _posts
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Posts"),
        backgroundColor: const Color(0xFF064789),
      ),
      body: _posts.isNotEmpty
          ? ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return buildPostCard(post); // Crea las tarjetas con los datos
        },
      )
          : const Center(child: CircularProgressIndicator()), // Muestra un indicador mientras carga
    );
  }

  Widget buildPostCard(Map<String, dynamic> post) {
    return Card(
      color: const Color(0xFF064789),
      margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen a la izquierda
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(post['imgUrl']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16), // Espacio entre la imagen y el texto
            // Contenido (Título, descripción y botón de Más Información)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    post['description'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      // Acciones del botón Más Información
                    },
                    child: const Text(
                      "Más Información",
                      style: TextStyle(
                        color: Color(0xFF064789),
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
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
