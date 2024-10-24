import 'package:app_mobile_plusroom/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile_plusroom/ui-initial-section/register_view.dart';


class LoginView extends StatelessWidget {
  const LoginView({super.key});
  static String id = 'login_view';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF78BCC4),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/icon_logo.jpeg',
                height: 100.0,
                fit: BoxFit.contain,
              ),
              textLogin(),
              const SizedBox(
                height: 15.0,
              ),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.1,
                    vertical: size.height * 0.07,
                  ),
                  child: Column(
                    children: [
                      emailInput(),
                      passwordInput(),
                    ],
                  ),
                ),
              ),
              notHaveAccount(context),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, BottomNavBar.id);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF427AA1),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  ),
                  child: const Text(
                    "Log In",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}

Widget notHaveAccount(context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "You do not have an account? ",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterView()),
            );
          },
          child: const Text(
            'Sign up',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF064789),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget textLogin() {
  return const Text(
    'Log In',
    style: TextStyle(
      fontSize: 40.0,
      fontWeight: FontWeight.bold,
      color: Color(0xFF064789),
    ),
  );
}

Widget emailInput() {
  return Container(
    child: TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 10, 9, 9),
          fontWeight: FontWeight.w700,
        ),
      ),
      onChanged: (value) {},
    ),
  );
}

Widget passwordInput() {
  return Container(
    child: TextField(
      keyboardType: TextInputType.emailAddress,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 12, 11, 11),
          fontWeight: FontWeight.w700,
        ),
      ),
      onChanged: (value) {},
    ),
  );
}