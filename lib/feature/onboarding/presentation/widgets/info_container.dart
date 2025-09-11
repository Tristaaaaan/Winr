import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppInfo extends StatelessWidget {
  const AppInfo({
    super.key,
    required this.title,
    required this.description1,
    this.description2,
    required this.imagePath,
    this.description3,
  });

  final String title;
  final String description1;
  final String? description2;
  final String imagePath;
  final String? description3;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 250,
              height: 250,
              child: SvgPicture.asset(height: 250, width: 250, imagePath),
            ),
          ),

          const SizedBox(height: 15),
          Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description1,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 10), // Adds spacing

          if (description2 != null)
            Text(
              description2!,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
            ),
          const SizedBox(height: 10), // Adds spacing

          if (description3 != null)
            Text(
              description3!,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
            ),
        ],
      ),
    );
  }
}
