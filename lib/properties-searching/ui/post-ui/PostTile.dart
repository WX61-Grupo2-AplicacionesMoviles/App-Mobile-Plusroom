import 'package:flutter/material.dart';
import 'package:app_mobile_plusroom/models/Post.dart';

import 'package:app_mobile_plusroom/properties-searching/ui/post-ui/post_detail.dart';

class PostTile extends StatelessWidget {
  final Post post;

  PostTile({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Color(0xFF064789), // Fondo azul oscuro
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: post.urlPhoto.isNotEmpty
                      ? Image.network(
                    post.urlPhoto,
                    width: 80,
                    height: 80, // Tamaño más grande de la imagen
                    fit: BoxFit.cover,
                  )
                      : Icon(Icons.image, color: Colors.white, size: 80),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Precio: \$${post.price}",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "Ubicación: ${post.location}",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "Disponible: ${post.available ? 'Sí' : 'No'}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF023859), // Color más oscuro para el botón
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetail(post: post),
                      ),
                    );
                  },
                  child: Text('Más información', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF023859), // Color más oscuro para el botón
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetail(post: post, isEditing: true),
                      ),
                    );
                  },
                  child: Text('Editar', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
