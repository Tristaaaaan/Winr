import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class ConvertImages {
  Future<String> encodeImageToBase64(File file) async {
    final bytes = await File(file.path).readAsBytes();
    return base64Encode(bytes);
  }

  Uint8List decodeBase64Image(String base64String) {
    return base64Decode(base64String);
  }
}
