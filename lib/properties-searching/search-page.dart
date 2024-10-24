import 'package:app_mobile_plusroom/pages/roomie_search_page.dart';
import 'package:app_mobile_plusroom/properties-searching/post-ui/filters.dart';
import 'package:app_mobile_plusroom/properties-searching/post-ui/property_list.dart';
import 'package:app_mobile_plusroom/properties-searching/post-ui/search_bar.dart';
import 'package:app_mobile_plusroom/shared/PostService.dart';
import 'package:flutter/material.dart';
import '../../models/Post.dart'; // Importa la pantalla de búsqueda de Roomies

class PropertiesPage extends StatefulWidget {
  const PropertiesPage({super.key});

  @override
  State<PropertiesPage> createState() => _PropertiesPageState();
}

class _PropertiesPageState extends State<PropertiesPage>
    with SingleTickerProviderStateMixin {
  final PostService _postService = PostService();
  List<Post> properties = [];
  List<Post> filteredProperties = [];
  TextEditingController searchController = TextEditingController();
  String? selectedCategory;
  late TabController _tabController; // TabController para manejar las pestañas

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Inicializa el TabController
    _tabController.addListener(_handleTabSelection); // Listener para cambios de pestaña
    fetchProperties();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose(); // Libera el TabController cuando no sea necesario
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.index == 1) { // Verifica si se selecciona la pestaña "Roomie"
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RoomieSearch()),
      );
    }
  }

  Future<void> fetchProperties() async {
    try {
      final List<Post> posts = await _postService.getPosts();
      setState(() {
        properties = posts;
        if (selectedCategory != null) {
          filterProperties(searchController.text);
        } else {
          filteredProperties = properties;
        }
      });
    } catch (e) {
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
      body: Column(
        children: [
          SearchBarSection(
            controller: searchController,
            onSearch: () {
              filterProperties(searchController.text);
            },
          ),
          // TabBar para cambiar entre "Inmuebles" y "Roomie"
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Inmuebles'),
              Tab(text: 'Roomie'),
            ],
            labelColor: Color(0xFF064789),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF064789),
          ),
          Expanded(
            child: _buildPropertiesBody(), // Pantalla de búsqueda de inmuebles
          ),
        ],
      ),
    );
  }

  Widget _buildPropertiesBody() {
    return Column(
      children: [
        Filters(
          filterOptions: const ['Apartment', 'Room', 'House'],
          selectedCategory: selectedCategory,
          onCategorySelected: (category) {
            setState(() {
              selectedCategory = category;
              filterProperties(searchController.text);
            });
          },
        ),
        Expanded(
          child: PropertyList(
            properties: filteredProperties,
            onDetailsPressed: () {},
            onRefresh: fetchProperties,
          ),
        ),
      ],
    );
  }
}
