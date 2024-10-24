import 'package:flutter/material.dart';
import '../../models/Post.dart';

class PropertyList extends StatelessWidget {
  final List<Post> properties;
  final VoidCallback onDetailsPressed;
  final Future<void> Function() onRefresh;

  const PropertyList({
    Key? key,
    required this.properties,
    required this.onDetailsPressed,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (properties.isEmpty) {
      return const Center(
        child: Text(
          'No properties found for this location.',
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        itemCount: properties.length,
        itemBuilder: (context, index) {
          final property = properties[index];
          return Card(
            color: const Color(0xFF064789),
            margin: const EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          property.title,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '\$${property.price}',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 150,
                      child: Image.network(
                        property.urlPhoto,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    property.description,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    property.location,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: onDetailsPressed,
                      child: const Text('Detalles'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF002C3E),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
