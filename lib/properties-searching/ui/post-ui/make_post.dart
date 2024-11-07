import 'package:flutter/material.dart';
import 'package:app_mobile_plusroom/shared/PostService.dart';
import 'package:app_mobile_plusroom/models/Post.dart';
import 'package:app_mobile_plusroom/properties-searching/ui/post-ui/list_posts.dart';

class MakePost extends StatefulWidget {
  static const id = 'MakePost';
  @override
  _MakePostState createState() => _MakePostState();
}

class _MakePostState extends State<MakePost> {
  final PostService _postService = PostService();
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController urlPhotoController = TextEditingController();

  // Variables para seleccionar categoría
  String? selectedCategory;

  Future<void> _submitPost() async {
    if (_formKey.currentState!.validate()) {
      final post = Post(
        id: 0,
        title: titleController.text,
        description: descriptionController.text,
        location: locationController.text,
        price: double.parse(priceController.text),
        category: selectedCategory ?? 'other', // Valor por defecto si no se selecciona categoría
        urlPhoto: urlPhotoController.text, // Toma el valor ingresado
        available: true,
        rooms: 1,
        bathrooms: 1,
        pets: false,
        smoking: false,
        landlordId: 1,
      );

      try {
        await _postService.createPost(post);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Publicación creada con éxito')),
        );
        Navigator.pushReplacementNamed(context, ListPosts.id); // Redirige a ListPosts
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear la publicación: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear Publicación')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) => value!.isEmpty ? 'Por favor, ingresa un título' : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (value) => value!.isEmpty ? 'Por favor, ingresa una descripción' : null,
              ),
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Ubicación'),
                validator: (value) => value!.isEmpty ? 'Por favor, ingresa una ubicación' : null,
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Por favor, ingresa un precio' : null,
              ),
              TextFormField(
                controller: urlPhotoController,
                decoration: InputDecoration(labelText: 'URL de la Imagen'),
                validator: (value) => value!.isEmpty ? 'Por favor, ingresa una URL de imagen' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Categoría'),
                value: selectedCategory,
                items: [
                  DropdownMenuItem(value: 'room', child: Text('Room')),
                  DropdownMenuItem(value: 'apartment', child: Text('Apartment')),
                  DropdownMenuItem(value: 'house', child: Text('House')),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                validator: (value) => value == null ? 'Por favor, selecciona una categoría' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Color(0xFF064789), // Color del texto en blanco
                ),
                onPressed: _submitPost,
                child: Text('Publicar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
