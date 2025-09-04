// Information SnackBar, used to show information using a snackbar
import 'package:flutter/material.dart';

void informationSnackBar(BuildContext context, IconData icon, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.surface),
          const SizedBox(width: 10),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      duration: const Duration(milliseconds: 3000),

      // ✅ Position adjustment
      margin: const EdgeInsets.only(
        bottom: 100, // move up from bottom
        left: 16, // side padding
        right: 90,
      ),
    ),
  );
}
