import 'package:flutter/material.dart';
import 'package:app_mobile_plusroom/models/roomie.dart';

class ClientDetailPage extends StatelessWidget {
  final Tenant client;

  const ClientDetailPage({
    super.key,
    required this.client,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Client Profile'),
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
                  // User image
                  client.photo.trim().isNotEmpty
                      ? CircleAvatar(
                    radius: 60.0,
                    backgroundImage: NetworkImage(client.photo),
                  )
                      : iconProfile(),

                  const SizedBox(height: 10),

                  // User name
                  Text(
                    client.name,
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
                    width: double.infinity,
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBF2FA),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        clientDetailInfo(),
                        const SizedBox(height: 10),
                        const Divider(color: Colors.grey, thickness: 1),
                        Text(
                          client.description ?? "",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Send message button
                  Center(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        side: const BorderSide(color: Colors.white, width: 1),
                      ),
                      onPressed: () {
                        // Implement messaging functionality or navigation to chat page here
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

  // Icon for profile image
  Widget iconProfile() {
    return const CircleAvatar(
      backgroundColor: Color(0xFF78BCC4),
      radius: 60,
      child: Icon(Icons.person, size: 60, color: Color(0xFF002C3E)),
    );
  }

  Widget clientDetailInfo() {
    return Column(
      children: [
        Row(
          children: [
            Icon(client.occupation == "Student" ? Icons.school : Icons.work, color: Colors.grey.shade500),
            const SizedBox(width: 10),
            Text(client.occupation),
          ],
        ),
        Row(
          children: [
            Icon(Icons.cake, color: Colors.grey.shade500),
            const SizedBox(width: 10),
            Text("${client.age}"),
          ],
        ),
        client.preferences.petFriendly
            ? Row(
          children: [
            Icon(Icons.pets, color: Colors.grey.shade500),
            const SizedBox(width: 10),
            const Text('Pet friendly'),
          ],
        )
            : Container(),
        client.preferences.smokingPreference
            ? Row(
          children: [
            Icon(Icons.smoking_rooms, color: Colors.grey.shade500),
            const SizedBox(width: 10),
            const Text('Smoker'),
          ],
        )
            : Container(),
        Row(
          children: [
            Icon(Icons.cleaning_services, color: Colors.grey.shade500),
            const SizedBox(width: 10),
            Expanded(child: Text('Cleaning habits: ${client.preferences.cleaningHabits}')),
          ],
        ),
        Row(
          children: [
            Icon(Icons.bedtime, color: Colors.grey.shade500),
            const SizedBox(width: 10),
            Expanded(child: Text('Sleeping habits: ${client.preferences.sleepingHabits}')),
          ],
        ),
        Row(
          children: [
            Icon(Icons.category_rounded, color: Colors.grey.shade500),
            const SizedBox(width: 10),
            const Text("Hobbies: "),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var hobby in client.preferences.hobbies)
                  Text("- $hobby"),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Icon(client.preferences.genderPreference == "male" ? Icons.male : Icons.female,
                color: client.preferences.genderPreference == "male" ? Colors.blue : Colors.pink),
            const SizedBox(width: 15),
            Text("Roomie gender preference: ${client.preferences.genderPreference == "male" ? "Male" : "Female"}"),
          ],
        ),
      ],
    );
  }
}
