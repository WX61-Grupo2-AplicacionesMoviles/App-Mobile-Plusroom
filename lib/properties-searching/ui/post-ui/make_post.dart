import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_mobile_plusroom/shared/PostService.dart';
import 'package:app_mobile_plusroom/services/MediaService.dart';
import 'package:app_mobile_plusroom/models/Post.dart';
import 'package:app_mobile_plusroom/properties-searching/ui/post-ui/list_posts.dart';

class MakePost extends StatefulWidget {
  static const id = 'MakePost';
  @override
  _MakePostState createState() => _MakePostState();
}

class _MakePostState extends State<MakePost> {
  final PostService _postService = PostService();
  final MediaService _mediaService = MediaService();
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  // Variables para seleccionar categoría y manejar imágenes
  String? selectedCategory;
  File? _selectedImage; // Para almacenar la imagen seleccionada
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  // Seleccionar imagen desde la galería
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Tomar foto con la cámara
  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Subir imagen al backend y obtener la URL
  Future<String> _uploadImage(File imageFile) async {
    try {
      final String imageUrl = await _mediaService.uploadImage(imageFile, 1); // Cambia el postId según corresponda
      return imageUrl;
    } catch (e) {
      throw Exception('Error al subir la imagen: $e');
    }
  }

  // Enviar la publicación al backend
  Future<void> _submitPost() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        // Verificar que se haya seleccionado una imagen
        if (_selectedImage == null) {
          throw Exception('Por favor, selecciona una imagen antes de publicar.');
        }

        // Subir la imagen al backend y obtener su URL
        String imageUrl = await _uploadImage(_selectedImage!);

        // Crear el objeto `Post`
        final post = Post(
          id: 0,
          title: titleController.text,
          description: descriptionController.text,
          location: locationController.text,
          price: double.parse(priceController.text),
          category: selectedCategory ?? 'other', // Valor por defecto
          urlPhoto: imageUrl, // La URL generada por el backend
          available: true,
          rooms: 1,
          bathrooms: 1,
          pets: false,
          smoking: false,
          landlordId: 1,
        );

        // Guardar la publicación
        await _postService.createPost(post);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Publicación creada con éxito')),
        );
        Navigator.pushReplacementNamed(context, ListPosts.id); // Redirige a la lista de publicaciones
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear la publicación: $e')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear Publicación')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) =>
                value!.isEmpty ? 'Por favor, ingresa un título' : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (value) => value!.isEmpty
                    ? 'Por favor, ingresa una descripción'
                    : null,
              ),
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Ubicación'),
                validator: (value) =>
                value!.isEmpty ? 'Por favor, ingresa una ubicación' : null,
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? 'Por favor, ingresa un precio' : null,
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
                validator: (value) => value == null
                    ? 'Por favor, selecciona una categoría'
                    : null,
              ),
              // Botones para seleccionar o tomar una imagen
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImageFromGallery,
                    icon: Icon(Icons.photo_library),
                    label: Text('Galería'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _takePhoto,
                    icon: Icon(Icons.camera_alt),
                    label: Text('Cámara'),
                  ),
                ],
              ),
              // Mostrar imagen seleccionada
              if (_selectedImage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Image.file(
                    _selectedImage!,
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
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
