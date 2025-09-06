import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:winr/common/components/buttons/regular_button.dart';

class DataPlaceHolder extends StatelessWidget {
  final String imagePath;
  final double imageHeight;
  final double imageWidth;
  final String title;
  final String description;
  final bool? withButton;
  final VoidCallback? onTap;
  final String buttonText;
  const DataPlaceHolder({
    super.key,
    required this.imagePath,
    required this.imageHeight,
    required this.imageWidth,
    required this.title,
    required this.description,
    this.withButton = false,
    this.onTap,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(height: imageHeight, width: imageWidth, imagePath),
            const SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              textAlign: TextAlign.center,
              description,
              style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 30),

            RegularButton(
              onTap: () {
                if (withButton!) {
                  onTap!();
                }
              },
              suffixIcon: false,
              text: buttonText,
              backgroundColor: Theme.of(context).colorScheme.surface,
              withBorder: true,

              textColor: Theme.of(context).colorScheme.primary,
              buttonKey: buttonText,
              width: 300,
              withIcon: false,
            ),
          ],
        ),
      ),
    );
  }
}
