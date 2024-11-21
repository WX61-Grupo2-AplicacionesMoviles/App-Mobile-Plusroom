import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_mobile_plusroom/models/Post.dart';
import 'package:app_mobile_plusroom/shared/PostService.dart';
import 'package:app_mobile_plusroom/services/MediaService.dart';

class PostDetail extends StatefulWidget {
  final Post post;
  final bool isEditing;

  PostDetail({required this.post, this.isEditing = false});

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  final PostService _postService = PostService();
  final MediaService _mediaService = MediaService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController locationController;
  late TextEditingController priceController;

  String? selectedCategory;
  File? _selectedImage; // Para manejar la imagen seleccionada
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.post.category;
    titleController = TextEditingController(text: widget.post.title);
    descriptionController = TextEditingController(text: widget.post.description);
    locationController = TextEditingController(text: widget.post.location);
    priceController = TextEditingController(text: widget.post.price.toString());
  }

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
      final String imageUrl = await _mediaService.uploadImage(imageFile, widget.post.id);
      return imageUrl;
    } catch (e) {
      throw Exception('Error al subir la imagen: $e');
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        String imageUrl = widget.post.urlPhoto;

        // Si se selecciona una nueva imagen, subirla al backend
        if (_selectedImage != null) {
          imageUrl = await _uploadImage(_selectedImage!);
        }

        final updatedPost = Post(
          id: widget.post.id,
          title: titleController.text,
          description: descriptionController.text,
          location: locationController.text,
          price: double.parse(priceController.text),
          category: selectedCategory ?? widget.post.category,
          urlPhoto: imageUrl,
          available: widget.post.available,
          rooms: widget.post.rooms,
          bathrooms: widget.post.bathrooms,
          pets: widget.post.pets,
          smoking: widget.post.smoking,
          landlordId: widget.post.landlordId,
        );

        await _postService.updatePost(updatedPost);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Publicación actualizada con éxito')),
        );

        Navigator.pop(context, 'updated'); // Retorna con el resultado "updated"
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar la publicación: $e')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _deletePost() async {
    try {
      await _postService.deletePost(widget.post.id);
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
      appBar: AppBar(title: Text('Editar Publicación')),
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
                validator: (value) =>
                value!.isEmpty ? 'Por favor, ingresa una descripción' : null,
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
              // Mostrar imagen seleccionada o la actual
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: _selectedImage != null
                    ? Image.file(
                  _selectedImage!,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                )
                    : Image.network(
                  widget.post.urlPhoto,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                child: Text('Guardar Cambios'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: _deletePost,
                child: Text(
                  'Eliminar Publicación',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
