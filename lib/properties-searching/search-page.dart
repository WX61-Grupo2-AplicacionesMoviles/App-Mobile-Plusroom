import 'package:app_mobile_plusroom/shared/PostService.dart';
import 'package:flutter/material.dart';
import '../../models/Post.dart';

class PropertiesPage extends StatefulWidget {
  const PropertiesPage({super.key});

  @override
  State<PropertiesPage> createState() => _PropertiesPageState();
}

class _PropertiesPageState extends State<PropertiesPage> {
  final PostService _postService = PostService();
  List<Post> properties = [];
  List<Post> filteredProperties = [];
  TextEditingController searchController = TextEditingController();
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    fetchProperties();
  }

  Future<void> fetchProperties() async {
    try {
      final List<Post> posts = await _postService.getPosts();
      setState(() {
        properties = posts;
        filteredProperties = properties;
      });
    } catch (e) {
      // Manejo de errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load properties: $e')),
      );
    }
  }

  void filterProperties(String location) {
    setState(() {
      filteredProperties = properties.where((property) {
        final matchesLocation = property.location.toLowerCase().contains(location.toLowerCase());
        final matchesCategory = selectedCategory == null || property.category.toLowerCase() == selectedCategory!.toLowerCase();
        return matchesLocation && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search',
          style: TextStyle(color: Color(0xFF064789)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF064789)),
        backgroundColor: Colors.white,
      ),
      body: _buildBody(),
    );
  }

  // Método para construir el cuerpo de la pantalla
  Widget _buildBody() {
    return _buildSearchContent();
  }

  // Método para construir el contenido de búsqueda
  Widget _buildSearchContent() {
    return Column(
      children: [
        _buildSearchBar(),
        _buildFilters(),
        Expanded(child: _buildPropertyList()),
      ],
    );
  }

  // Método para construir la barra de búsqueda
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.grey[200],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Enter a location',
                  hintStyle: TextStyle(color: Color(0xFF064789)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10.0),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Color(0xFF064789)),
              onPressed: () {
                filterProperties(searchController.text);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir los filtros
  Widget _buildFilters() {
    final filters = ['Apartment', 'Room', 'House'];

    return SizedBox(
      height: 50.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ChoiceChip(
              label: Text(
                filters[index],
                style: const TextStyle(color: Colors.white),
              ),
              selected: selectedCategory == filters[index],
              selectedColor: const Color(0xFF064789),
              backgroundColor: Colors.grey,
              onSelected: (isSelected) {
                setState(() {
                  if (isSelected) {
                    selectedCategory = filters[index];
                  } else {
                    selectedCategory = null;
                  }
                  filterProperties(searchController.text);
                });
              },
            ),
          );
        },
      ),
    );
  }

  // Método para construir la lista de propiedades
  Widget _buildPropertyList() {
    if (filteredProperties.isEmpty) {
      return const Center(
        child: Text(
          'No properties found for this location.',
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredProperties.length,
      itemBuilder: (context, index) {
        final property = filteredProperties[index];
        return Card(
          color: const Color(0xFF064789),
          margin: const EdgeInsets.all(10.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        property.title,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '\$${property.price}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Center(
                  child: SizedBox(
                    width: 200,
                    height: 150,
                    child: Image.network(
                      property.urlPhoto,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  property.description,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5.0),
                Text(
                  property.location,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Detalles de ${property.title}'),
                        ),
                      );
                    },
                    child: const Text('Detalles'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002C3E),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
