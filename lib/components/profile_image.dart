import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String roomiePhoto;
  final double radius;

  const ProfileImage({
    super.key,
    required this.roomiePhoto,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return  CircleAvatar(
      backgroundImage: image(),
      radius: radius,
    );
  }


  // evaluate if the roomiePhoto is not empty
  ImageProvider image() {
    return roomiePhoto.trim().isNotEmpty
        ? Image.network(
            roomiePhoto,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {

              // if error -> return default image
              return Image.asset(
                'assets/images/user.png',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              );
            },
          ).image
        : Image.asset(
            'assets/images/user.png',  // default image
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          ).image;
  }
}
