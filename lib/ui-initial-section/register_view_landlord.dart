import 'package:flutter/material.dart';
import 'package:app_mobile_plusroom/ui-initial-section/login_view.dart';
import 'package:app_mobile_plusroom/shared/service/api_service.dart';

class RegisterViewLandlord extends StatelessWidget {
  RegisterViewLandlord({super.key});
  static String id = 'register_view_landlord';

  final ApiService apiService = ApiService(baseUrl: 'https://giving-perception-production.up.railway.app');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final TextEditingController nameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController ageController = TextEditingController();
    final TextEditingController genderController = TextEditingController();
    final TextEditingController photoController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFF78BCC4),
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
                padding: EdgeInsets.all(16.0),
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
                        child: Column(
                          children: [
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 10, 9, 9),
                                ),
                              ),
                            ),
                            TextField(
                              controller: lastNameController,
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 10, 9, 9),
                                ),
                              ),
                            ),
                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 10, 9, 9),
                                ),
                              ),
                            ),
                            TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 12, 11, 11),
                                ),
                              ),
                            ),
                            TextField(
                              controller: confirmPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 12, 11, 11),
                                ),
                              ),
                            ),
                            TextField(
                              controller: descriptionController,
                              decoration: InputDecoration(
                                labelText: 'Description',
                                labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 10, 9, 9),
                                ),
                              ),
                            ),
                            TextField(
                              controller: ageController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Age',
                                labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 10, 9, 9),
                                ),
                              ),
                            ),
                            TextField(
                              controller: genderController,
                              decoration: InputDecoration(
                                labelText: 'Gender',
                                labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 10, 9, 9),
                                ),
                              ),
                            ),
                            TextField(
                              controller: photoController,
                              decoration: InputDecoration(
                                labelText: 'Photo URL',
                                labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 10, 9, 9),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextButton(
                              onPressed: () async {
                                try {
                                  final response = await apiService.registerLandlord(
                                    nameController.text,
                                    lastNameController.text,
                                    emailController.text,
                                    passwordController.text,
                                    descriptionController.text,
                                    int.parse(ageController.text),
                                    genderController.text,
                                    photoController.text,
                                  );
                                  if (response.statusCode == 200) {
                                    // Handle successful registration
                                    print("Registration successful");
                                  } else {
                                    // Handle error
                                    print("Error: ${response.statusCode}");
                                  }
                                } catch (e) {
                                  print("Error: ${e.toString()}");
                                }
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Color(0xFF427AA1),
                                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                              ),
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'By registering, you accept our Terms of Use and Privacy Policy',
                      style: TextStyle(
                        color: Color(0xFF454040),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    haveAccount(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textRegister() {
    return Text(
      'Register as Landlord',
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
          Text(
            "Have an account? ",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, LoginView.id);
            },
            child: Text(
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
}