import 'package:flutter/material.dart';

class FilterRoomieButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final bool isSelected;

  const FilterRoomieButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: isSelected ? Colors.lightBlue.shade900 : Colors.lightBlue.shade100,
        foregroundColor: isSelected ? Colors.white : Colors.blue.shade900,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
