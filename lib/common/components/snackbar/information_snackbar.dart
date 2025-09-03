// Information SnackBar, used to show information using a snackbar
import 'package:flutter/material.dart';

void informationSnackBar(BuildContext context, IconData icon, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          // Wrap text and allow it to expand vertically
          Expanded(
            child: Text(
              text,
              softWrap: true,
              overflow: TextOverflow.visible,
              style: TextStyle(color: Theme.of(context).colorScheme.surface),
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      duration: const Duration(
        milliseconds: 3000,
      ), // increased to allow time to read
    ),
  );
}
