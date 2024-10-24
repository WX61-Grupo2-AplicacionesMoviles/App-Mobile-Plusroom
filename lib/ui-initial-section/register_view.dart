import 'package:flutter/material.dart';
import 'package:app_mobile_plusroom/ui-initial-section/login_view.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});
  static String id = 'register_view';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF78BCC4),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'lib/assets/icon_logo.jpeg',
                height: 100.0,
                fit: BoxFit.contain,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textRegister(),
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.1,
                          vertical: size.height * 0.04,
                        ),
                        child: formRegister(),
                      ),
                    ),
                    const SizedBox(height: 10), // Added space
                    const Text(
                      'Al registrarte, aceptas nuestras Condiciones de uso y Politicas de privacidad',
                      style: TextStyle(
                        color: Color(0xFF454040),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    haveAccount(context),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, LoginView.id);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF427AA1),
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        ),
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget textRegister() {
  return const Text(
    'Register',
    style: TextStyle(
      fontSize: 40.0,
      fontWeight: FontWeight.bold,
      color: Color(0xFF064789),
    ),
  );
}

Widget haveAccount(context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Have an account? ",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginView()),
            );
          },
          child: const Text(
            'Log In',
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

Widget formRegister() {
  return Column(
    children: [
      TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          labelText: 'Name',
          labelStyle: TextStyle(
            color: Color.fromARGB(255, 10, 9, 9),
          ),
        ),
        onChanged: (value) {},
      ),
      TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          labelText: 'Last Name',
          labelStyle: TextStyle(
            color: Color.fromARGB(255, 10, 9, 9),
          ),
        ),
        onChanged: (value) {},
      ),
      TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          labelText: 'Email',
          labelStyle: TextStyle(
            color: Color.fromARGB(255, 10, 9, 9),
          ),
        ),
        onChanged: (value) {},
      ),
      TextField(
        keyboardType: TextInputType.emailAddress,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: 'Password',
          labelStyle: TextStyle(
            color: Color.fromARGB(255, 12, 11, 11),
          ),
        ),
        onChanged: (value) {},
      ),
      TextField(
        keyboardType: TextInputType.emailAddress,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: 'Confirm password',
          labelStyle: TextStyle(
            color: Color.fromARGB(255, 12, 11, 11),
          ),
        ),
        onChanged: (value) {},
      ),
    ],
  );
}