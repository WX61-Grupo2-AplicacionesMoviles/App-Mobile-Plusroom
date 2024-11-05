import 'package:app_mobile_plusroom/pages/request_form.dart';
import 'package:flutter/material.dart';

import '../components/text_item.dart';
import 'author_profile.dart';

class PostDetail extends StatelessWidget {
  //final Post post;

  const PostDetail({
    super.key,
    //required this.post,
  });

  void sendRequest() {
    print("Request sent");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Detail"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // post image
            Container(
              margin: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  "https://img.freepik.com/foto-gratis/sala-estar-lujo-loft-representacion-3d-estanteria_105762-2182.jpg?t=st=1730684069~exp=1730687669~hmac=7b50ba6876b1eabbff0aeefd367d1220da02698c181feedcf6b98ab2d16908ff&w=2000",
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // button landlord profile
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.lightBlue.shade100,
                foregroundColor: Colors.black,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                // width 100
                minimumSize: Size(180, 40),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AuthorProfile()));
              },
              child: Text("Go to Landlord profile"),
            ),

            // button request
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                // width 100
                minimumSize: Size(180, 40),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RequestForm()));
              },
              child: Text("Request"),
            ),

            // card post details
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
                  TextItem(
                      title: "Title",
                      titleSize: 18,
                      text: "Post title",
                      textSize: 16),
                  TextItem(
                      title: "Description",
                      titleSize: 18,
                      text: "Post description",
                      textSize: 16),
                  TextItem(
                      title: "Characteristics",
                      titleSize: 18,
                      text: "Post description",
                      textSize: 16),
                  TextItem(
                      title: "Location",
                      titleSize: 18,
                      text: "Post location",
                      textSize: 16),
                  Center(
                    child: RichText(
                        text: TextSpan(
                          text: "Price: ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(
                              text: "Post price",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )),
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
