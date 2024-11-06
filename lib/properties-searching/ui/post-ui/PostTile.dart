import 'package:flutter/material.dart';
import 'package:app_mobile_plusroom/models/Post.dart';
import 'package:app_mobile_plusroom/properties-searching/ui/post-ui/post_detail.dart'; // Importa PostDetail

class PostTile extends StatelessWidget {
  final Post post;

  PostTile({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        children: [
          ListTile(
            leading: post.urlPhoto.isNotEmpty
                ? Image.network(post.urlPhoto, width: 50, height: 50, fit: BoxFit.cover)
                : Icon(Icons.image),
            title: Text(post.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Precio: \$${post.price}"),
                Text("Ubicación: ${post.location}"),
                Text("Disponible: ${post.available ? 'Sí' : 'No'}"),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetail(post: post),
                    ),
                  );
                },
                child: Text('Más información'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetail(post: post, isEditing: true),
                    ),
                  );
                },
                child: Text('Editar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
