import 'package:app_mobile_plusroom/pages/request_form.dart';
import 'package:flutter/material.dart';

import '../components/text_item.dart';
import '../models/Post.dart';
import 'author_profile.dart';

class PostDetail extends StatelessWidget {
  final Post post;

  const PostDetail({
    super.key,
    required this.post,
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
                child: Image.network(post.urlPhoto,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuthorProfile(landlordId: post.landlordId),
                  ),
                );
              },
              child: Text("Go to Landlord profile"),
            ),

            // button request
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                minimumSize: Size(180, 40),
              ),
              onPressed: () {
                try {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RequestForm()));
                } catch (error) {
                  print('Error al navegar: $error');
                }
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
                      text: post.title,
                      textSize: 16),
                  TextItem(
                      title: "Description",
                      titleSize: 18,
                      text: post.description,
                      textSize: 16),
                  TextItem(
                    title: "Characteristics",
                    titleSize: 18,
                    text: '${post.rooms} rooms, ${post.bathrooms} bathrooms, ${post.pets ? 'pet friendly' : 'no pets'}, ${post.smoking ? 'allow smoking' : 'no smoking'}',
                    textSize: 16,
                  ),
                  TextItem(
                      title: "Location",
                      titleSize: 18,
                      text: post.location,
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
                              text: '\$${post.price}',
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
