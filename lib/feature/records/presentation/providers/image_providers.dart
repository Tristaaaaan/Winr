import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final uploadImagePathProvider = StateProvider<List<File>>((ref) => []);

final uploadImagePathNameProvider = StateProvider<List<String>>((ref) => []);

final uploadImageNameProvider = StateProvider<List<String>>((ref) => []);

final isImageRemovedProvider = StateProvider<bool>((ref) => false);
