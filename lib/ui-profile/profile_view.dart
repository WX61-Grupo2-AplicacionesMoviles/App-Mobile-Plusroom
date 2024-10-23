import 'package:flutter/material.dart';
//import 'package:renstatefrontend/properties-searching/ui/post-ui/YourPosts.dart';
//import 'package:renstatefrontend/see-your-clients/ui/see_clients.dart';
//import 'package:renstatefrontend/shared/appBarApp.dart';
//import 'package:renstatefrontend/shared/bottomNavigationApp.dart';
import 'package:app_mobile_plusroom/shared/buttonApp.dart';
//import '../shared/showImageProfile.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
  static String id = 'profile_view';


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 7, 64, 129),
      //appBar: appBarApp(context),
      body: Center(
        child: ListView(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  //child: showImageProfile(),
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
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    cardInfo(context, "Rafael"),
                    cardInfo(context, "Lopez Perez"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        cardInfo(context, "33"),
                        cardInfo(context, "Male"),
                      ]
                    ),
                    cardInfo(context, "rafael@gmail.com"),
                    cardInfo(context, "Here is description about of user"),
                    SizedBox(height: 20.0,),
                    FractionallySizedBox(
                      widthFactor: 0.5,
                      child: buttonApp(
                          "Save",
                              (){

                          }
                      ),
                    ),
                    SizedBox(height: 5,),
                    FractionallySizedBox(
                      widthFactor: 0.5,
                      /*child: buttonApp(
                          "Your Clients",
                          (){
                            Navigator.push(
                              context,
                            MaterialPageRoute(builder: (context)=>ClientsView()));
                          }),*/
                    ),
                    SizedBox(height: 5,),
                    FractionallySizedBox(
                      widthFactor: 0.5,
                      /*child: buttonApp(
                          "Your Posts",
                              (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context)=>YourPosts()));
                          }),*/
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      //bottomNavigationBar: bottomNavigationApp(context),
    );
  }
}

Widget cardInfo(context, String info){
  final size = MediaQuery.of(context).size;

  return Card(
    color: Colors.white,
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.1,
        vertical: 15,
      ),
      child:
      Center(
        child: Text(
          info,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 12, 11, 11),
          ),
        ),
      )
    ),
  );
}