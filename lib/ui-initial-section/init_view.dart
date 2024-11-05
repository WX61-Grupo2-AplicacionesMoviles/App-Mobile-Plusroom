import 'package:flutter/material.dart';
import 'package:app_mobile_plusroom/ui-initial-section/register_view.dart';
import 'package:app_mobile_plusroom/ui-initial-section/register_view_landlord.dart';
import 'package:app_mobile_plusroom/ui-initial-section/login_view.dart';

class InitView extends StatelessWidget {
  const InitView({super.key});
  static String id = 'init_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF064789),
      body: Center(
        child: SizedBox(
          width: double.infinity,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Positioned(
                top: 20,
                child: Text(
                  'Welcome to',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                top: 60,
                child: Image.asset(
                  'lib/assets/icon_plusroom.jpeg',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 100.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 150, // Set a fixed width for both buttons
              child: buildStyledButton(
                "LOG IN",
                    () {
                  Navigator.pushNamed(context, LoginView.id);
                },
                Colors.white,
                Colors.black,
                const Color(0xFF427AA1),
              ),
            ),
            SizedBox(
              width: 150, // Set a fixed width for both buttons
              child: buildStyledButton(
                "REGISTER",
                    () {
                  showRegisterDialog(context);
                },
                const Color(0xFF427AA1),
                const Color(0xFF427AA1),
                Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showRegisterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Elige tu cuenta',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterViewLandlord()),
                      );
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'lib/assets/landlord.jpeg',
                          width: 100,
                          height: 100,
                        ),
                        const SizedBox(height: 10),
                        const Text('Arrendatario'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterView()),
                      );
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'lib/assets/tenant.jpeg',
                          width: 100,
                          height: 100,
                        ),
                        const SizedBox(height: 10),
                        const Text('Arrendador'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

ElevatedButton buildStyledButton(
    String label,
    Function onPressed,
    Color backgroundColor,
    Color borderColor,
    Color textColor,
    ) {
  return ElevatedButton(
    onPressed: () {
      onPressed();
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(color: borderColor, width: 1),
      ),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14.0, // Adjusted font size
        color: textColor,
      ),
    ),
  );
}