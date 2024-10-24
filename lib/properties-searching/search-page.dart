// search-page.dart
import 'package:app_mobile_plusroom/properties-searching/post-ui/filters.dart';
import 'package:app_mobile_plusroom/properties-searching/post-ui/property_list.dart';
import 'package:app_mobile_plusroom/properties-searching/post-ui/search_bar.dart';
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
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        SearchBarSection(
          controller: searchController,
          onSearch: () {
            filterProperties(searchController.text);
          },
        ),
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
            onDetailsPressed: () {

            },
            onRefresh: fetchProperties,
          ),
        ),
      ],
    );
  }
}
