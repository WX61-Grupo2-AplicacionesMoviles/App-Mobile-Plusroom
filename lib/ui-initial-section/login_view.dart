import 'package:flutter/material.dart';
//import 'package:renstatefrontend/shared/buttonApp.dart';
//import 'package:renstatefrontend/shared/logo.dart';
import 'package:app_mobile_plusroom/ui-initial-section/register_view.dart';
import 'package:app_mobile_plusroom/ui-initial-section/welcome_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});
  static String id = 'login_view';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF78BCC4),
      body: Center(
        child: Column(
          children: [
            //logo(),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textLogin(),
                  SizedBox(
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
                  //buttonApp(
                  //  "Log In",
                  //    (){
                  //      Navigator.pushNamed(context, WelcomeView.id);
                  //    }
                  //)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget notHaveAccount(context){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("You do not have an account? ", style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterView()),
            );
          },
          child: Text(
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


Widget textLogin(){
    return Text(
      'Log In',
      style: TextStyle(
        fontSize: 40.0,
        fontWeight: FontWeight.bold,
        color: Color(0xFF064789),
      ),
    );
}

Widget emailInput(){
  return Container(
    child: TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
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
Widget passwordInput(){
  return Container(
    child: TextField(
      keyboardType: TextInputType.emailAddress,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 12, 11, 11),
          fontWeight: FontWeight.w700,
        ),
      ),
      onChanged: (value) {},
    )
  );
}
