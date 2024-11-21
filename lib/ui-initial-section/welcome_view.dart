import 'dart:convert';
import 'package:app_mobile_plusroom/router/routes.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile_plusroom/shared/buttonApp.dart';
import 'package:provider/provider.dart';
import '../models/Post.dart';
import '../models/landlord.dart';
import '../pages/notification_list.dart';
import '../pages/post_detail.dart';
import '../shared/PostService.dart';
import 'package:http/http.dart' as http;

class WelcomeView extends StatefulWidget {
  final int? tenantId;
  final int? landlordId;

  const WelcomeView({super.key, this.tenantId, this.landlordId});
  static String id = 'welcome_view';

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {

  final PostService _postService = PostService();
  List<Post> propertiesWithSub = [];

  // carousel
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  void initState() {
    super.initState();
    fetchProperties();
    _fetchLandlords();
  }

  Future<void> _fetchLandlords() async {
    final response = await http.get(Uri.parse('https://easygoing-perception-production.up.railway.app/api/landlords'));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      final landlordProvider = Provider.of<LandlordProvider>(context, listen: false);
      landlordProvider.setLandlords(
        jsonData.map((landlord) => Landlord.fromJson(landlord)).toList(),
      );

    } else {
      throw Exception('Error to get landlords data');
    }
  }

  Future<void> fetchProperties() async {
    try {
      final List<Post> subPosts = await _postService.getPosts();
      setState(() {
        propertiesWithSub = subPosts;
        propertiesWithSub = propertiesWithSub.sublist(0, 4);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load properties with subscription: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final landlordProvider = Provider.of<LandlordProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotificationList()));
            },
            icon: Icon(Icons.notifications),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/assets/welcome_plusroom.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          // Foreground content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Card(
                    color: Colors.white.withOpacity(0.8),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.1,
                        vertical: size.height * 0.05,
                      ),
                      child: Column(
                        children: [
                          tittleWelcome(),
                          const SizedBox(height: 15.0),
                          textWelcome(),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                buttonApp(
                  "See my profile",
                      () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavBar(
                          initialIndex: 4,
                          tenantId: widget.tenantId,
                          landlordId: widget.landlordId,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 15.0),

                Flexible(
                  child: CarouselSlider(
                      carouselController: _controller,
                      items: propertiesWithSub.map((post){
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          decoration: BoxDecoration(
                            color: Color(0xFF064789), // Fondo azul oscuro
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: post.urlPhoto.isNotEmpty
                                          ? Image.network(
                                        post.urlPhoto,
                                        width: 80,
                                        height: 80, // Tamaño más grande de la imagen
                                        fit: BoxFit.cover,
                                      )
                                          : Icon(Icons.image, color: Colors.white, size: 80),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            post.title,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            "Precio: \$${post.price}",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            "Ubicación: ${post.location}",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            "Disponible: ${post.available ? 'Sí' : 'No'}",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF023859), // Color más oscuro para el botón
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => PostDetail(
                                                post: post,
                                              )),
                                        );
                                      },
                                      child: Text('Más información', style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList() ,
                      options: CarouselOptions(
                          height: 250,
                          viewportFraction: 1,
                          autoPlay: true,
                          aspectRatio: 2.0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          })),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget tittleWelcome() {
  return const Text(
    'WELCOME',
    style: TextStyle(
      fontSize: 25.0,
      fontWeight: FontWeight.bold,
      color: Color.fromARGB(255, 140, 214, 225),
    ),
  );
}

Widget textWelcome() {
  return const Center(
    child: Text(
      'To complete your registration, we recommend that you complete your information to improve your profile',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 12, 11, 11),
      ),
      textAlign: TextAlign.center,
    ),
  );
}

class LandlordProvider with ChangeNotifier {
  List<Landlord> _landlords = [];

  List<Landlord> get landlords => _landlords;

  void setLandlords(List<Landlord> newLandlords) {
    _landlords = newLandlords;
    notifyListeners();
  }

  void updateRating(int landlordId, double rating) {
    landlords.firstWhere((landlord) => landlord.id == landlordId).rating = rating;
    notifyListeners();
  }
}
