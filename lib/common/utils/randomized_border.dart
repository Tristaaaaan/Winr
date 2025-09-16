// Utility to randomize which corners get rounded
import 'dart:math';

import 'package:flutter/material.dart';

BorderRadius randomBorderRadius(double radius, {double defaultRadius = 10}) {
  final rand = Random();
  return BorderRadius.only(
    topLeft: rand.nextBool()
        ? Radius.circular(radius)
        : Radius.circular(defaultRadius),
    topRight: rand.nextBool()
        ? Radius.circular(radius)
        : Radius.circular(defaultRadius),
    bottomLeft: rand.nextBool()
        ? Radius.circular(radius)
        : Radius.circular(defaultRadius),
    bottomRight: rand.nextBool()
        ? Radius.circular(radius)
        : Radius.circular(defaultRadius),
  );
}
