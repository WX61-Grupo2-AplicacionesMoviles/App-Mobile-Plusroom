import 'package:app_mobile_plusroom/components/filter_roomie_button.dart';
import 'package:app_mobile_plusroom/components/roomie_tile.dart';
import 'package:app_mobile_plusroom/services/roomie_service.dart';
import 'package:flutter/material.dart';
import '../models/roomie.dart';

class RoomieSearch extends StatefulWidget {
  @override
  State<RoomieSearch> createState() => _RoomieSearchState();
}

class _RoomieSearchState extends State<RoomieSearch> {

  bool showSectionRoomies = false;

  final RoomieService _roomieService = RoomieService();

  // selected filters
  bool filterStudent = false;
  bool filterProfessional = false;
  bool filterPets = false;
  bool filterNonSmoker = false;

  // roomie info storage
  List<Roomie> allRoomies = [];
  List<Roomie> filteredRoomies = [];

  // set show section state
  void _setShowSectionRoomies() {
    setState(() {
      showSectionRoomies = !showSectionRoomies;
    });
  }

  Future<void> _fetchRoomies() async {
    try {
      List<Roomie> roomies = await _roomieService.getRoomies();
      setState(() {
        allRoomies = roomies;
        filteredRoomies = roomies;
      });
    } catch (error) {
      print('Error al obtener roomies: $error');
    }
  }

  // Filtrar roomies en base a los filtros seleccionados
  void _applyFilters() {
    setState(() {
      filteredRoomies = allRoomies.where((roomie) {
        // check if roomie matches filters
        bool matchesStudent =
            !filterStudent || roomie.occupation == "Estudiante";
        bool matchesProfessional =
            !filterProfessional || roomie.occupation == "Profesional";
        bool matchesPets = !filterPets || roomie.pets == true;
        bool matchesNonSmoker = !filterNonSmoker || roomie.smoker == false;

        return matchesStudent &&
            matchesProfessional &&
            matchesPets &&
            matchesNonSmoker;
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchRoomies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Search",
          style: TextStyle(
            fontSize: 24,
            color: Colors.blue.shade800,
          ),
        ),
      ),
      body: Column(
        children: [

          // show roomies section
          TextButton(
            onPressed: () {
              _setShowSectionRoomies();
            },
            child: Text("Roomies", style: TextStyle(
              fontSize: 20,
              color: Colors.blue.shade900,
            ),),
          ),

          // filters buttons
          showSectionRoomies ?
          filterButtons() : Container(),

          // roomies list
          showSectionRoomies ?
          Expanded(
            child: _buildRoomieList(),
          ) : Container(),
        ],
      ),
    );
  }


  Widget _buildRoomieList() {
    return FutureBuilder(
      future: _roomieService.getRoomies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Loading
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Error
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // No data
          return const Center(child: Text('No roomies disponibles'));
        } else {

          // Mostrar la lista de roomies
          List<Roomie> roomies = snapshot.data!;
          return ListView.builder(
              itemCount: filteredRoomies.length,
              itemBuilder: (context, index) {
                final Roomie roomie = filteredRoomies[index];
                return RoomieTile(roomie: roomie);
              });
        }
      },
    );
  }

  Widget filterButtons() {
    return Column(
      children: [
        // roomies buttons filter
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FilterRoomieButton(
                text: "Estudiante",
                onPressed: () {
                  setState(() {
                    // If already selected, deselect it
                    // If not selected, select "Estudiante" and deselect "Profesional"
                    if (filterStudent) {
                      filterStudent = false;
                    } else {
                      filterStudent = true;
                      filterProfessional = false;
                    }
                  });
                  _applyFilters();
                },
                isSelected: filterStudent,
              ),
              FilterRoomieButton(
                text: "Profesional",
                onPressed: () {
                  setState(() {
                    // If already selected, deselect it
                    // If not selected, select "Profesional" and deselect "Estudiante"
                    if (filterProfessional) {
                      filterProfessional = false;
                    } else {
                      filterProfessional = true;
                      filterStudent = false;
                    }
                  });
                  _applyFilters();
                },
                isSelected: filterProfessional,
              ),
              FilterRoomieButton(
                text: "Mascotas",
                onPressed: () {
                  setState(() {
                    filterPets = !filterPets;
                  });
                  _applyFilters();
                },
                isSelected: filterPets,
              ),
              FilterRoomieButton(
                text: "No fumador",
                onPressed: () {
                  setState(() {
                    filterNonSmoker = !filterNonSmoker;
                  });
                  _applyFilters();
                },
                isSelected: filterNonSmoker,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
