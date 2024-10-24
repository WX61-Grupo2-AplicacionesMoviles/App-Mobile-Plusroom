import 'package:flutter/material.dart';
//import 'package:renstatefrontend/shared/appBarApp.dart';
//import 'package:renstatefrontend/shared/bottomNavigationApp.dart';
//import 'package:renstatefrontend/shared/showImageProfile.dart';
//import 'package:renstatefrontend/ui-mesagge/receivedMessages.dart';

class ProfileAuthor extends StatefulWidget {
  const ProfileAuthor({super.key});

  @override
  State<ProfileAuthor> createState() => _ProfileAuthorState();
}

class _ProfileAuthorState extends State<ProfileAuthor> {

  int selectedStar = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: appBarApp(context),
      body: Center(
        child: ListView(
          children: [
            //showImageProfile(),
            showStars(selectedStar),
            const SizedBox(height: 25.0),
            const FractionallySizedBox(
              widthFactor: 0.7,
              /*child: buttonApp("Send Message",
                      (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=>ReceivedMessages())
                    );
                  }),*/
            ),
            const SizedBox(height: 25.0,),
            showInfoProfile(),
            const SizedBox(height: 30.0,),
            rateSection(),
          ],
        )
      ),
      //bottomNavigationBar: bottomNavigationApp(context),
    );
  }

  Widget rateSection() {
    return FractionallySizedBox(
      widthFactor: 0.8,
      child: Column(
        children: [
          const Text(
            "Rate this user",
            style: TextStyle(
              color: Colors.black,
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  (selectedStar == index + 1)?selectedStar = 0 : selectedStar = index + 1;
                  setState(() {});
                },
                child: Icon(
                  index < selectedStar ? Icons.star : Icons.star_border,
                  color: Colors.black45,
                  size: 40.0,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

}

Widget showStars(int rank) {
  int maxStars = 5;
  double starSize = 35.0;
  List<Widget> starIcons = [];

  for (int i = 0; i < rank; i++) {
    starIcons.add(Icon(Icons.star, color: Colors.yellow, size: starSize));
  }

  for (int i = rank; i < maxStars; i++) {
    starIcons.add(Icon(Icons.star_border, color: Colors.yellow, size: starSize));
  }

  return Center(
    child: Padding(
      padding: const EdgeInsets.only(top:20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: starIcons,
      ),
    ),
  );
}

Widget showInfoProfile(){
  return const FractionallySizedBox(
    widthFactor: 0.8,
    child: Card(
      color: Color(0xFF002C3E),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("Rafael Lopez Reyes",
              style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 25.0),
            Text("Rafael Lopez Reyes At faucibus purus aliquet. Curabitur scelerisque, justo eu suscipit suscipit, diam augue fermentum mauris",
              style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}





