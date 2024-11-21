import 'package:flutter/material.dart';
import 'package:app_mobile_plusroom/ui-initial-section/login_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> registerLandlord(Map<String, dynamic> userData) async {
  final url = Uri.parse('https://easygoing-perception-production.up.railway.app/api/landlords');
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(userData),
  );

  if (response.statusCode == 200) {
    print('Landlord registrado exitosamente');
  } else {
    print('Error al registrar landlord: ${response.statusCode}');
    print('Cuerpo de la respuesta: ${response.body}');
  }
}

class RegisterViewLandlord extends StatefulWidget {
  const RegisterViewLandlord({super.key});
  static String id = 'register_view_landlord';

  @override
  _RegisterViewLandlordState createState() => _RegisterViewLandlordState();
}

class _RegisterViewLandlordState extends State<RegisterViewLandlord> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _agreeToTerms = false;

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
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _agreeToTerms,
                          onChanged: (bool? value) {
                            setState(() {
                              _agreeToTerms = value ?? false;
                            });
                          },
                        ),
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                              text: 'By registering, you agree to our ',
                              style: const TextStyle(
                                color: Color(0xFF454040),
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: 'terms and conditions',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      final Uri url = Uri.parse('https://www.freeprivacypolicy.com/live/141d55ef-a8ab-4854-86fd-4c7a19ba2490');
                                      try {
                                        if (!await launchUrl(
                                          url,
                                          mode: LaunchMode.externalApplication,
                                        )) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('No se pudo abrir los términos y condiciones'),
                                              ),
                                            );
                                          }
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Error: ${e.toString()}'),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    haveAccount(context),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: TextButton(
                        onPressed: _agreeToTerms
                            ? () async {
                          Map<String, dynamic> userData = {
                            'name': _nameController.text,
                            'lastName': _lastNameController.text,
                            'email': _emailController.text,
                            'password': _passwordController.text,
                            'description': '',
                            'dni': '',
                            'age': 0,
                            'gender': '',
                            'occupation': '',
                            'searchRoomie': true,
                            'photo': ''
                          };
                          await registerLandlord(userData);
                          Navigator.pushNamed(context, LoginView.id);
                        }
                            : null,
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

  Widget formRegister() {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(
            labelText: 'Name',
            labelStyle: TextStyle(
              color: Color.fromARGB(255, 10, 9, 9),
            ),
          ),
        ),
        TextField(
          controller: _lastNameController,
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(
            labelText: 'Last Name',
            labelStyle: TextStyle(
              color: Color.fromARGB(255, 10, 9, 9),
            ),
          ),
        ),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email',
            labelStyle: TextStyle(
              color: Color.fromARGB(255, 10, 9, 9),
            ),
          ),
        ),
        TextField(
          controller: _passwordController,
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(
              color: Color.fromARGB(255, 12, 11, 11),
            ),
          ),
        ),
        TextField(
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Confirm password',
            labelStyle: TextStyle(
              color: Color.fromARGB(255, 12, 11, 11),
            ),
          ),
        ),
      ],
    );
  }
}

Widget textRegister() {
  return const Text(
    'Register Landlord',
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