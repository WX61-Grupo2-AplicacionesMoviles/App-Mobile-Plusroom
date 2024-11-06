import 'package:flutter/material.dart';
import 'package:app_mobile_plusroom/models/Post.dart';
import 'package:app_mobile_plusroom/shared/PostService.dart';

class PostDetail extends StatefulWidget {
  final Post post;
  final bool isEditing;

  PostDetail({required this.post, this.isEditing = false});

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  final PostService _postService = PostService();
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController locationController;
  late TextEditingController priceController;
  late TextEditingController urlPhotoController;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    isEditing = widget.isEditing;
    titleController = TextEditingController(text: widget.post.title);
    descriptionController = TextEditingController(text: widget.post.description);
    locationController = TextEditingController(text: widget.post.location);
    priceController = TextEditingController(text: widget.post.price.toString());
    urlPhotoController = TextEditingController(text: widget.post.urlPhoto);
  }

  Future<void> _saveChanges() async {
    final updatedPost = Post(
      id: widget.post.id,
      title: titleController.text,
      description: descriptionController.text,
      location: locationController.text,
      price: double.parse(priceController.text),
      category: widget.post.category,
      urlPhoto: urlPhotoController.text,
      available: widget.post.available,
      rooms: widget.post.rooms,
      bathrooms: widget.post.bathrooms,
      pets: widget.post.pets,
      smoking: widget.post.smoking,
      landlordId: widget.post.landlordId,
    );

    try {
      await _postService.updatePost(updatedPost); // Este método deberá crearse en `PostService`
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Publicación actualizada con éxito')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar la publicación: $e')),
      );
    }
  }

  Future<void> _deletePost() async {
    try {
      await _postService.deletePost(widget.post.id); // Método `deletePost` en `PostService`
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Publicación eliminada con éxito')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la publicación: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar Publicación' : 'Detalles de la Publicación')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (isEditing) ...[
              TextField(controller: titleController, decoration: InputDecoration(labelText: 'Título')),
              TextField(controller: descriptionController, decoration: InputDecoration(labelText: 'Descripción')),
              TextField(controller: locationController, decoration: InputDecoration(labelText: 'Ubicación')),
              TextField(controller: priceController, decoration: InputDecoration(labelText: 'Precio'), keyboardType: TextInputType.number),
              TextField(controller: urlPhotoController, decoration: InputDecoration(labelText: 'URL de la Imagen')),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _saveChanges, child: Text('Guardar Cambios')),
            ] else ...[
              Text("Título: ${widget.post.title}"),
              Text("Descripción: ${widget.post.description}"),
              Text("Ubicación: ${widget.post.location}"),
              Text("Precio: \$${widget.post.price}"),
              Text("Categoría: ${widget.post.category}"),
              // Otros detalles
            ],
            if (isEditing)
              TextButton(
                onPressed: _deletePost,
                child: Text('Eliminar Publicación', style: TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
