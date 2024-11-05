import 'dart:convert';
import 'package:app_mobile_plusroom/properties-searching/post-ui/filters.dart';
import 'package:app_mobile_plusroom/properties-searching/post-ui/property_list.dart';
import 'package:app_mobile_plusroom/properties-searching/post-ui/search_bar.dart';
import 'package:app_mobile_plusroom/shared/PostService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/Post.dart';
import '../components/filter_roomie_button.dart';
import '../components/roomie_tile.dart';
import '../models/roomie.dart';
import '../services/roomie_service.dart';

class PropertiesPage extends StatefulWidget {
  const PropertiesPage({super.key});

  @override
  State<PropertiesPage> createState() => _PropertiesPageState();
}

class _PropertiesPageState extends State<PropertiesPage>
    with SingleTickerProviderStateMixin {
  final PostService _postService = PostService();
  final RoomieService _roomieService = RoomieService();

  // Controladores y variables para ambas pestañas
  List<Post> properties = [];
  List<Post> filteredProperties = [];
  List<Tenant> roomies = [];
  List<Tenant> filteredRoomies = [];

  TextEditingController searchController = TextEditingController();
  String? selectedCategory;
  late TabController _tabController;

  // Filtros específicos para roomies
  bool filterStudent = false;
  bool filterProfessional = false;
  bool filterPets = false;
  bool filterNonSmoker = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Forzar reconstrucción al cambiar de pestaña
    });
    fetchProperties();

    // first load rommie data, then preferences
    _fetchRoomies().then((value) => findRoomiePreferences());
  }
  void _getRoomieJsonData() async {
    final String response = await rootBundle.loadString('lib/assets/db.json');
    final data = await json.decode(response);

    setState(() {
      roomies = (data['tenants'] as List<dynamic>)
          .map((roomieData) => Tenant.fromJson(roomieData))
          .toList();
      filteredRoomies = List.from(roomies); // Usa roomies como base de filteredRoomies
    });
  }
  Future<void> fetchProperties() async {
    try {
      final List<Post> posts = await _postService.getPosts();
      setState(() {
        properties = posts;
        filteredProperties = posts;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load properties: $e')),
      );
    }
  }

  Future<void> _fetchRoomies() async {
    try {
      List<Tenant> data = await _roomieService.getRoomies();
      setState(() {
        roomies = data;
        filteredRoomies = data;
      });

      //print data
      print("Tenants loaded: $roomies");
    } catch (error) {
      print('Error al obtener roomies: $error');
    }
  }

  Future<void> _fetchRoomiePreference(Tenant roomie) async {
    try {
      Preferences? data = await _roomieService.getRoomiePreferenceById(roomie);
      setState(() {
        roomie.preferences = data;
      });

      //print data
      print("Preferences loaded: $data");
    } catch (error) {
      print('Error al obtener preferencias del roomie: $error');
    }
  }

  void findRoomiePreferences() async {
    await Future.forEach(roomies, (Tenant roomie) async {
      await _fetchRoomiePreference(roomie);
      print("from findRoomiePreferences: $roomie");
    });
    setState(() {
      // ensure all roomies have preferences
      roomies = roomies.where((roomie) => roomie.preferences != null).toList();
      filteredRoomies = roomies; // Update filtered roomies
    });
  }

  void filterProperties(String query) {
    setState(() {
      if (_tabController.index == 0) {
        // Filtrar inmuebles
        filteredProperties = properties.where((property) {
          return property.location.toLowerCase().contains(query.toLowerCase()) &&
              (selectedCategory == null || property.category.toLowerCase() == selectedCategory!.toLowerCase());
        }).toList();
      } else {
        // Filtrar roomies
        filteredRoomies = roomies.where((roomie){ // Cambiado a filteredRoomies
          bool matchesLocation = roomie.preferences!.locationPreference.toLowerCase().contains(query.toLowerCase());
          bool matchesStudent = !filterStudent || roomie.occupation == "Student";
          bool matchesProfessional = !filterProfessional || roomie.occupation != "Student";
          bool matchesPets = !filterPets || roomie.preferences!.petFriendly == true;
          bool matchesNonSmoker = !filterNonSmoker || roomie.preferences!.smokingPreference == false;

          return matchesLocation && matchesStudent && matchesProfessional && matchesPets && matchesNonSmoker;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search', style: TextStyle(color: Color(0xFF064789))),
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
            child: _tabController.index == 0 ? _buildPropertiesBody() : _buildRoomiesBody(),
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

  Widget _buildRoomiesBody() {
    return Column(
      children: [
        filterButtons(),
        Expanded(
          child: filteredRoomies.isNotEmpty
              ? ListView.builder(
                  itemCount: filteredRoomies.length,
                  itemBuilder: (context, index) {
                    final roomie = filteredRoomies[index];
                    return RoomieTile(roomie: roomie);
                  },
                )
              : const Center(child: Text("No roomies available", style: TextStyle(fontSize: 18, color: Colors.red),)),
        ),
      ],
    );
  }

  Widget filterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FilterRoomieButton(
          text: "Student",
          onPressed: () {
            setState(() {
              filterStudent = !filterStudent;
              filterProfessional = false;
              filterProperties(searchController.text);
            });
          },
          isSelected: filterStudent,
        ),
        FilterRoomieButton(
          text: "Professional",
          onPressed: () {
            setState(() {
              filterProfessional = !filterProfessional;
              filterStudent = false;
              filterProperties(searchController.text);
            });
          },
          isSelected: filterProfessional,
        ),
        FilterRoomieButton(
          text: "Pet friendly",
          onPressed: () {
            setState(() {
              filterPets = !filterPets;
              filterProperties(searchController.text);
            });
          },
          isSelected: filterPets,
        ),
        FilterRoomieButton(
          text: "No smoker",
          onPressed: () {
            setState(() {
              filterNonSmoker = !filterNonSmoker;
              filterProperties(searchController.text);
            });
          },
          isSelected: filterNonSmoker,
        ),
      ],
    );
  }
}

