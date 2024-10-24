import 'package:app_mobile_plusroom/components/profile_image.dart';
import 'package:flutter/material.dart';
import '../models/roomie.dart';

class RoomiePage extends StatelessWidget {
  final Tenant roomie;

  const RoomiePage({
    super.key,
    required this.roomie,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Roomie profile'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              // Profile photo
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // user image
                  roomie.photo.trim().isNotEmpty ? ProfileImage(roomiePhoto: roomie.photo, radius: 60.0,) : iconProfile(),
        
                  const SizedBox(height: 10),
        
                  // user name
                  Text(
                    roomie.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
        
              const SizedBox(height: 15),
        
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description box
                  Container(
                    width: double.infinity, // full width
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBF2FA),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        roomieDetailInfo(),
                        const SizedBox(height: 10),
                        const Divider(color: Colors.grey, thickness: 1),
                        Text(
                          roomie.description ?? "",
                        ),
                      ],
                    ),
                  ),
        
                  const SizedBox(height: 25),

        
                  const SizedBox(height: 25),
        
                  Center(
                    child: // send message
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue.shade900,
                            foregroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            side: const BorderSide(color: Colors.white, width: 1),
                          ),
                          onPressed: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => ChatPage(
                            //         userName: roomie.name,
                            //       ),
                            //     ));
                            },
                          child: const Text("Send message"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  // icon for profile image
  Widget iconProfile() {
    return const CircleAvatar(
      backgroundColor: Color(0xFF78BCC4),
      radius: 60,
      child: Icon(Icons.person, size: 60, color: Color(0xFF002C3E)),
    );
  }


  Widget roomieDetailInfo() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            roomie.occupation == "Student"
                ? Icon(Icons.school, color: Colors.grey.shade500,)
                : Icon(Icons.work, color: Colors.grey.shade500,),
            const SizedBox(width: 10),
            Text(roomie.occupation)
          ],
        ),
        Row(
          children: [
            Icon(Icons.cake, color: Colors.grey.shade500,),
            const SizedBox(width: 10),
            Text("${roomie.age}"),
          ],
        ),
        roomie.preferences.petFriendly == true
            ? Row(
                children: [
                  Icon(Icons.pets, color: Colors.grey.shade500,),
                  const SizedBox(width: 10),
                  const Text('Pet friendly'),
                ],
              )
            : Container(),
        roomie.preferences.smokingPreference == true
            ? Row(
                children: [
                  Icon(Icons.smoking_rooms, color: Colors.grey.shade500,),
                  const SizedBox(width: 10),
                  const Text('Smoker'),
                ],
              )
            : Container(),
        Row(
          children: [
            Icon(Icons.cleaning_services, color: Colors.grey.shade500,),
            const SizedBox(width: 10),
            Expanded(child: Text('Cleaning habits: ${roomie.preferences.cleaningHabits}')),
          ],
        ),
        Row(
          children: [
            Icon(Icons.bedtime, color: Colors.grey.shade500,),
            const SizedBox(width: 10),
            Expanded(child: Text('Sleeping habits: ${roomie.preferences.sleepingHabits}')),
          ],
        ),
        Row(
          children: [
            Icon(Icons.category_rounded, color: Colors.grey.shade500,),
            const SizedBox(width: 10),
            const Text("Hobbies: "),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var hobby in roomie.preferences.hobbies)
                  Text("- $hobby"),
              ],
            ),
          ],
        ),
        Row(
          children: [
            roomie.preferences.genderPreference == "male"
                ? const Icon(Icons.male, color: Colors.blue,)
                : const Icon(Icons.female, color: Colors.pink,),
            const SizedBox(width: 15),
            roomie.preferences.genderPreference == "male"
                ? const Text("Roomie gender preference: Male")
                : const Text("Roomie gender preference: Female"),
          ],
        )
      ],
    );
  }
}
