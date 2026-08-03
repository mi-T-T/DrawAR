import 'dart:typed_data';
import 'package:image/image.dart' as img;

class SketchService {
  Future<Uint8List> convertToSketch(
    Uint8List imageBytes, {
    int threshold = 120,
    bool invert = false,
  }) async {
    img.Image? image = img.decodeImage(imageBytes);

    if (image == null) {
      return imageBytes;
    }

    // Chuyển ảnh sang xám
    image = img.grayscale(image);

    // Làm mịn
    image = img.gaussianBlur(image, radius: 2);

    // Tìm cạnh
    image = img.sobel(image);

    // Chuyển thành trắng đen
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);

        final isEdge = pixel.r > threshold;

        if (invert) {
          // Nền trắng - nét đen
          if (isEdge) {
            image.setPixelRgb(x, y, 0, 0, 0);
          } else {
            image.setPixelRgb(x, y, 255, 255, 255);
          }
        } else {
          // Nền đen - nét trắng
          if (isEdge) {
            image.setPixelRgb(x, y, 255, 255, 255);
          } else {
            image.setPixelRgb(x, y, 0, 0, 0);
          }
        }
      }
    }

    return Uint8List.fromList(img.encodePng(image));
  }
}
