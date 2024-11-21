import 'package:app_mobile_plusroom/models/current_user.dart';
import 'package:app_mobile_plusroom/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile_plusroom/ui-initial-section/register_view.dart';
import 'package:app_mobile_plusroom/ui-initial-section/register_view_landlord.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

int? tenantId; // Variable to store tenant ID
int? landlordId; // Variable to store landlord ID

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  static String id = 'login_view';

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> loginUser(String email, String password) async {
    final tenantUrl = Uri.parse('https://easygoing-perception-production.up.railway.app/api/tenants/login');
    final landlordUrl = Uri.parse('https://easygoing-perception-production.up.railway.app/api/landlords/login');

    // Try logging in as a tenant
    final tenantResponse = await http.post(
      tenantUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (tenantResponse.statusCode == 200) {
      final responseData = jsonDecode(tenantResponse.body);
      if (responseData is int) {
        CurrentUser().setId(responseData);
        CurrentUser().setRole('tenant');
        tenantId = responseData; // Store tenant ID
        print('Tenant authenticated successfully. ID: $tenantId');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavBar(initialIndex: 0, tenantId: tenantId),
          ),
        );
        return;
      }
    }

    // If tenant login fails, try logging in as a landlord
    final landlordResponse = await http.post(
      landlordUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (landlordResponse.statusCode == 200) {
      final responseData = jsonDecode(landlordResponse.body);
      if (responseData is int) {
        CurrentUser().setId(responseData);
        CurrentUser().setRole('landlord');
        landlordId = responseData; // Store landlord ID
        print('Landlord authenticated successfully. ID: $landlordId');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavBar(initialIndex: 0, landlordId: landlordId),
          ),
        );
      } else {
        print('Unexpected server response: $responseData');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error logging in. Unexpected server response.')),
        );
      }
    } else {
      print('Error authenticating user: ${landlordResponse.statusCode}');
      print('Response body: ${landlordResponse.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging in. Check your credentials.')),
      );
    }
  }

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
                  onPressed: () async {
                    await loginUser(_emailController.text, _passwordController.text);
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

  Widget emailInput() {
    return Container(
      child: TextField(
        controller: _emailController,
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
        controller: _passwordController,
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
}