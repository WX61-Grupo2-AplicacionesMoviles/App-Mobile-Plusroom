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

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();


  String? selectedCategory;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage(File imageFile, int postId) async {
    try {
      return await _mediaService.uploadImage(imageFile, postId);
    } catch (e) {
      throw Exception('Error al subir la imagen: $e');
    }
  }

  Future<void> _submitPost() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final post = Post(
          id: 0,
          title: titleController.text,
          description: descriptionController.text,
          location: locationController.text,
          price: double.parse(priceController.text),
          category: selectedCategory ?? 'other',
          urlPhoto: 'https://t3.ftcdn.net/jpg/08/57/81/74/360_F_857817431_QvW1YME2z5HVi74FLR0TFCGrdsRhcXA7.jpg', // Valor temporal
          available: true,
          rooms: 1,
          bathrooms: 1,
          pets: false,
          smoking: false,
          landlordId: 1,
        );


        final createdPost = await _postService.createPost(post);

        if (_selectedImage != null) {
          final String imageUrl = await _uploadImage(_selectedImage!, createdPost.id);

          final updatedPost = Post(
            id: createdPost.id,
            title: createdPost.title,
            description: createdPost.description,
            location: createdPost.location,
            price: createdPost.price,
            category: createdPost.category,
            urlPhoto: imageUrl,
            available: createdPost.available,
            rooms: createdPost.rooms,
            bathrooms: createdPost.bathrooms,
            pets: createdPost.pets,
            smoking: createdPost.smoking,
            landlordId: createdPost.landlordId,
          );

          await _postService.updatePost(updatedPost);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Publicación creada con éxito')),
        );
        Navigator.pushReplacementNamed(context, ListPosts.id);
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
