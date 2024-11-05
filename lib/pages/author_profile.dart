import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../components/profile_image.dart';
import '../components/text_item.dart';

class AuthorProfile extends StatelessWidget {
  const AuthorProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Landlord Profile"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //  image
            SizedBox(height: 20),
            ProfileImage(
              roomiePhoto:
              "https://cdn-icons-png.freepik.com/512/9131/9131478.png",
              radius: 60.0,
            ),

            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  // send message button
                  TextButton(
                    onPressed: () {},
                    child: Text("Send message"),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.lightBlue.shade100,
                      foregroundColor: Colors.black87,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                  ),

                  SizedBox(height: 20),

                  // landlord information
                  Container(
                    width: double.infinity,
                    // full width
                    padding: const EdgeInsets.all(15.0),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade900,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child: Text("LANDLORD NAME", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),)),

                        SizedBox(height: 15),

                        TextItem(
                            title: "Landlord information",
                            titleSize: 18,
                            text: "Info",
                            textSize: 16),
                        TextItem(
                            title: "Description",
                            titleSize: 18,
                            text: "info description",
                            textSize: 16),
                        TextItem(
                            title: "Phone number",
                            titleSize: 18,
                            text: "number",
                            textSize: 16),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  Text(
                    "Rate this landlord:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade900,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: RatingBar.builder(
                      initialRating: 3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

