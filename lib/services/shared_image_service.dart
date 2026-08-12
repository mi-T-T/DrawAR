import 'dart:io';
import 'dart:typed_data';

class SharedImageService {
  static File? originalImage;

  static Uint8List? processedImage;

  static bool isSketchMode = false;

  static bool invert = false;

  static void clear() {
    originalImage = null;
    processedImage = null;
    isSketchMode = false;
    invert = false;
  }
}
