// post-ui/filters.dart
import 'package:flutter/material.dart';

class Filters extends StatelessWidget {
  final List<String> filterOptions;
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  const Filters({
    Key? key,
    required this.filterOptions,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filterOptions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ChoiceChip(
              label: Text(
                filterOptions[index],
                style: const TextStyle(color: Colors.white),
              ),
              selected: selectedCategory == filterOptions[index],
              selectedColor: const Color(0xFF064789),
              backgroundColor: Colors.grey,
              onSelected: (isSelected) {
                onCategorySelected(isSelected ? filterOptions[index] : null);
              },
            ),
          );
        },
      ),
    );
  }
}
