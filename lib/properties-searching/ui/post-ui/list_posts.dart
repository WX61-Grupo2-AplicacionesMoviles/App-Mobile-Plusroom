import 'package:flutter/material.dart';
import 'package:app_mobile_plusroom/models/Post.dart';
import 'package:app_mobile_plusroom/shared/PostService.dart';
import 'package:app_mobile_plusroom/properties-searching/ui/post-ui/PostTile.dart';
import 'package:app_mobile_plusroom/properties-searching/ui/post-ui/post_detail.dart';

class ListPosts extends StatefulWidget {
  static const id = 'ListPosts';
  @override
  _ListPostsState createState() => _ListPostsState();
}

class _ListPostsState extends State<ListPosts> {
  final PostService _postService = PostService();
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = _postService.getPosts(); // Cargamos los datos inicialmente
  }

  // Método para recargar los datos de publicaciones
  Future<void> _refreshPosts() async {
    setState(() {
      _postsFuture = _postService.getPosts(); // Recargamos el Future
    });
    await _postsFuture; // Esperamos a que el Future se complete
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Publicaciones'),
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture, // Usamos la variable _postsFuture
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar las publicaciones: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tienes publicaciones aún.'));
          } else {
            return RefreshIndicator(
              onRefresh: _refreshPosts, // Llama al método de recarga cuando se hace scroll hacia abajo
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final post = snapshot.data![index];
                  return GestureDetector(
                    onTap: () async {
                      // Esperamos el resultado de la pantalla de detalles
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PostDetail(post: post)),
                      );
                      // Si el resultado es "updated", recargamos los datos
                      if (result == 'updated') {
                        _refreshPosts(); // Recargamos los datos al volver de la edición
                      }
                    },
                    child: PostTile(post: post),
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
