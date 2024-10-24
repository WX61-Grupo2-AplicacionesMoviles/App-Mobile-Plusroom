import 'package:flutter/material.dart';
import 'package:app_mobile_plusroom/shared/buttonApp.dart';
import 'package:app_mobile_plusroom/ui-profile/edit_profile_roomie.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
  static String id = 'profile_view';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('lib/assets/img_profile.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Rafael Lopez Perez',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                ),
                Text(
                  'Rafael Lopez Perez',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 239, 237, 237),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    cardInfo(context, "Rafael"),
                    cardInfo(context, "Lopez Perez"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        cardInfo(context, "33"),
                        cardInfo(context, "Male"),
                      ],
                    ),
                    cardInfo(context, "rafael@gmail.com"),
                    cardInfo(context, "987654321"),
                    cardInfo(context, "Here is description about of user"),
                    const SizedBox(height: 20.0),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10.0, bottom: 50.0),
                        child: Row(
                          children: [
                            Image.asset(
                              'lib/assets/icon_pets.png',
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(width: 8.0),
                            const Text(
                              'Con mascotas',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      child: FractionallySizedBox(
                        widthFactor: 0.5,
                        child: buttonApp(
                          "Editar Perfil",
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditProfileRoomie(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const FractionallySizedBox(
                      widthFactor: 0.5,
                    ),
                    const SizedBox(height: 5),
                    const FractionallySizedBox(
                      widthFactor: 0.5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget cardInfo(context, String info) {
  final size = MediaQuery.of(context).size;

  return Card(
    color: const Color(0xFFD9D9D9),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.1,
        vertical: 15,
      ),
      child: Center(
        child: Text(
          info,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 12, 11, 11),
          ),
        ),
      ),
    ),
  );
}