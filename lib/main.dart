import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF064789), // Color del tema principal
        ),
        useMaterial3: true,
      ),
      home: const PropertiesPage(),
    );
  }
}

class PropertiesPage extends StatefulWidget {
  const PropertiesPage({super.key});

  @override
  State<PropertiesPage> createState() => _PropertiesPageState();
}

class _PropertiesPageState extends State<PropertiesPage> {
  int selectedSection = 0; // Sección seleccionada
  List<Map<String, dynamic>> properties = [];
  List<Map<String, dynamic>> filteredProperties = [];
  TextEditingController searchController = TextEditingController();
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    fetchProperties();
  }

  Future<void> fetchProperties() async {
    final response = await http.get(Uri.parse(
        'https://giving-perception-production.up.railway.app/api/posts'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        properties = data.map((item) => item as Map<String, dynamic>).toList();
        filteredProperties = properties;
      });
    } else {
      throw Exception('Failed to load properties');
    }
  }

  void filterProperties(String location) {
    setState(() {
      filteredProperties = properties.where((property) {
        final matchesLocation = property['location'].toLowerCase().contains(location.toLowerCase());
        final matchesCategory = selectedCategory == null || property['category'].toLowerCase() == selectedCategory!.toLowerCase();
        return matchesLocation && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(), // Cambiado para obtener el título basado en la sección
          style: const TextStyle(color: Color(0xFF064789)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF064789)),
        backgroundColor: Colors.white,
      ),
      body: _buildBody(), // Cambiado para construir el cuerpo
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedSection,
        onTap: (index) {
          setState(() {
            selectedSection = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color(0xFF064789)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Color(0xFF064789)),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF002C3E), // Color del botón central
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white), // Ícono del botón central
            ),
            label: 'Add Property',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message, color: Color(0xFF064789)),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Color(0xFF064789)),
            label: 'Profile',
          ),
        ],
        backgroundColor: Colors.white, // Fondo de la barra de navegación
        selectedItemColor: const Color(0xFF064789), // Color de los íconos seleccionados
        unselectedItemColor: const Color(0xFF064789), // Color de los íconos no seleccionados
      ),
    );
  }

  // Método para obtener el título del AppBar basado en la sección seleccionada
  String _getAppBarTitle() {
    switch (selectedSection) {
      case 0:
        return 'Home';
      case 1:
        return 'Search';
      case 2:
        return 'Add Property';
      case 3:
        return 'Messages';
      case 4:
        return 'Profile';
      default:
        return 'Home';
    }
  }

  // Método para construir el cuerpo de la pantalla
  Widget _buildBody() {
    switch (selectedSection) {
      case 0:
        return const Center(child: Text('Home', style: TextStyle(fontSize: 24)));
      case 1:
        return _buildSearchContent(); // Muestra el contenido de búsqueda aquí
      case 2:
        return const Center(child: Text('Add Property', style: TextStyle(fontSize: 24)));
      case 3:
        return const Center(child: Text('Messages', style: TextStyle(fontSize: 24)));
      case 4:
        return const Center(child: Text('Profile', style: TextStyle(fontSize: 24)));
      default:
        return const Center(child: Text('Home', style: TextStyle(fontSize: 24)));
    }
  }

  // Método para construir el contenido de búsqueda
  Widget _buildSearchContent() {
    return Column(
      children: [
        _buildSearchBar(), // Muestra la barra de búsqueda
        _buildFilters(), // Muestra los filtros
        Expanded(child: _buildPropertyList()), // Muestra la lista de propiedades
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
                decoration: InputDecoration(
                  hintText: 'Enter a location',
                  hintStyle: const TextStyle(color: Color(0xFF064789)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(10.0),
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
                        property['title'],
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
                      '\$${property['price']}',
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
                      property['urlPhoto'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  property['description'],
                  style: const TextStyle(color: Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5.0),
                Text(
                  property['location'],
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10.0),
                // Aquí agregas el botón de Detalles
                Align(
                  alignment: Alignment.centerRight, // Alinear el botón a la derecha
                  child: ElevatedButton(
                    onPressed: () {
                      // Aquí puedes definir la acción del botón
                      // Por ejemplo, mostrar un diálogo o una notificación
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Detalles de ${property['title']}'),
                        ),
                      );
                    },
                    child: const Text('Detalles'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002C3E), // Color de fondo del botón
                      foregroundColor: Colors.white, // Color del texto del botón
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
