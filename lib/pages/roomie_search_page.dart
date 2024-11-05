import 'dart:convert';
import 'package:app_mobile_plusroom/components/filter_roomie_button.dart';
import 'package:app_mobile_plusroom/components/roomie_tile.dart';
import 'package:app_mobile_plusroom/services/roomie_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/roomie.dart';

class RoomieSearch extends StatefulWidget {
  @override
  State<RoomieSearch> createState() => _RoomieSearchState();
}

class _RoomieSearchState extends State<RoomieSearch> {

  bool showSectionRoomies = false;

  final TextEditingController _searchController = TextEditingController();
  final RoomieService _roomieService = RoomieService();

  // selected filters
  bool filterStudent = false;
  bool filterProfessional = false;
  bool filterPets = false;
  bool filterNonSmoker = false;

  // roomie info storage
  List<Tenant> allRoomies = [];
  List<Tenant> filteredRoomies = [];

  // set show section state
  void _setShowSectionRoomies() {
    setState(() {
      showSectionRoomies = !showSectionRoomies;
    });
  }

  Future<void> _fetchRoomies() async {
    try {
      List<Tenant> roomies = await _roomieService.getRoomies();
      setState(() {
        allRoomies = roomies;
        filteredRoomies = roomies;
      });
    } catch (error) {
      print('Error al obtener roomies: $error');
    }
  }

  // search roomie by location
  void search() {
    final search = _searchController.text;
    if (search.isNotEmpty) {
      setState(() {
        filteredRoomies = allRoomies
            .where((roomie) => roomie.preferences.locationPreference
            .toLowerCase()
            .contains(search.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        filteredRoomies = allRoomies;
      });
    }
  }

  // filter controller
  void _applyFilters() {
    setState(() {
      filteredRoomies = allRoomies.where((roomie) {
        // check if roomie matches filters
        bool matchesStudent =
            !filterStudent || roomie.occupation == "Student";
        bool matchesProfessional =
            !filterProfessional || roomie.occupation != "Student";
        bool matchesPets = !filterPets || roomie.preferences.petFriendly == true;
        bool matchesNonSmoker = !filterNonSmoker || roomie.preferences.smokingPreference == false;

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
    // _fetchRoomies();
    _getRoomieJsonData();
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

          // search bar
          searchBar(),

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
                  child: filteredRoomies.isNotEmpty
                      ? ListView.builder(
                          itemCount: filteredRoomies.length,
                          itemBuilder: (context, index) {
                            final roomie = filteredRoomies[index];
                            return RoomieTile(roomie: roomie);
                          },
                        )
                      : const Center(
                          // child: CircularProgressIndicator(),
                          child: Text("No roomies available"),
                        ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget searchBar() {
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
                controller: _searchController,
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
              onPressed: search,
            ),
          ],
        ),
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
          return const Center(child: Text('No roomies available'));
        } else {

          // show roomies list
          List<Tenant> roomies = snapshot.data!;
          return ListView.builder(
              itemCount: filteredRoomies.length,
              itemBuilder: (context, index) {
                final Tenant roomie = filteredRoomies[index];
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
                text: "Student",
                onPressed: () {
                  setState(() {
                    // If already selected, deselect it
                    // If not selected, select "Student" and deselect "Professional"
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
                text: "Professional",
                onPressed: () {
                  setState(() {
                    // If already selected, deselect it
                    // If not selected, select "Professional" and deselect "Student"
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
                text: "Pet friendly",
                onPressed: () {
                  setState(() {
                    filterPets = !filterPets;
                  });
                  _applyFilters();
                },
                isSelected: filterPets,
              ),
              FilterRoomieButton(
                text: "No smoker",
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

  // obtain data by json
  Future<void> _getRoomieJsonData() async {
    final String response = await rootBundle.loadString('lib/assets/db.json');
    print("Response: $response");
    final data = await json.decode(response);

    setState(() {
      allRoomies = (data['tenants'] as List<dynamic>)
          .map((roomieData) => Tenant.fromJson(roomieData))
          .toList();
      filteredRoomies = allRoomies;
    });
  }
}
