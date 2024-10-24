import 'package:flutter/material.dart';
import 'package:app_mobile_plusroom/shared/buttonApp.dart';
import 'package:app_mobile_plusroom/ui-profile/profile_view.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});
  static String id = 'welcome_view';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        color: Colors.white.withOpacity(0.8),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.1,
                            vertical: size.height * 0.05,
                          ),
                          child: Column(
                            children: [
                              tittleWelcome(),
                              SizedBox(height: 15.0),
                              textWelcome(),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      buttonApp(
                        "See my profile",
                            () {
                          Navigator.pushNamed(context, ProfileView.id);
                        },
                      ),
                    ],
                  ),
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
  return Text(
    'WELCOME',
    style: TextStyle(
      fontSize: 25.0,
      fontWeight: FontWeight.bold,
      color: Color.fromARGB(255, 140, 214, 225),
    ),
  );
}

Widget textWelcome() {
  return Center(
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