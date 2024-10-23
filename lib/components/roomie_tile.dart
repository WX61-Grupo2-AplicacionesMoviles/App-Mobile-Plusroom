import 'package:app_mobile_plusroom/components/profile_image.dart';
import 'package:app_mobile_plusroom/models/roomie.dart';
import 'package:flutter/material.dart';
import '../pages/roomie_detail_page.dart';

class RoomieTile extends StatelessWidget {
  final Roomie roomie;

  RoomieTile({
    super.key,
    required this.roomie,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF5F7F8),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(

        // profile image -> if empty show icon
        leading: roomie.photo.trim().isNotEmpty ? ProfileImage(roomiePhoto: roomie.photo, radius: 30.0,) : iconProfile(),
        title: Row(
          children: [

            // name & last name
            Text('${roomie.name} ${roomie.lastName}'),

            // gender
            roomie.gender == "female"
                ? const Icon(
                    Icons.female,
                    color: Colors.pink,
                    size: 20,
                  )
                : const Icon(
                    Icons.male,
                    color: Colors.blue,
                    size: 20,
                  ),
          ],
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // occupation, pets, smoker
            roomieInfo(),

            const SizedBox(height: 5),

            // more info button
            moreInfoButton(context),
          ],
        ),
        onTap: () {
          print('Roomie seleccionado: ${roomie.name}');
        },
      ),
    );
  }


  // icon for profile image
  Widget iconProfile() {
    return const CircleAvatar(
      backgroundColor: Color(0xFF78BCC4),
      radius: 30,
      child: Icon(Icons.person, size: 35, color: Color(0xFF002C3E)),
    );
  }


  // roomie occupation, pets, smoker
  Widget roomieInfo() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            roomie.occupation == "Estudiante"
                ? const Icon(Icons.school)
                : const Icon(Icons.work),
            const SizedBox(width: 5),
            Text(roomie.occupation)
          ],
        ),
        roomie.pets == true
            ? const Row(
                children: [
                  Icon(Icons.pets),
                  SizedBox(width: 5),
                  Text('Mascotas'),
                ],
              )
            : Container(),
        roomie.smoker == true
            ? const Row(
                children: [
                  Icon(Icons.smoking_rooms),
                  SizedBox(width: 5),
                  Text('Fumador'),
                ],
              )
            : Container(),
      ],
    );
  }

  // button -> detail roomie info
  Widget moreInfoButton(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xFF427AA1),
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        side: const BorderSide(
          color: Colors.white,
          width: 1,
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoomiePage(
              roomie: roomie,
            ),
          ),
        );
      },
      child: const Text(
        "Más información",
      ),
    );
  }
}
