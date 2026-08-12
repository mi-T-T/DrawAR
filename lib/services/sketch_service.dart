import 'dart:typed_data';
import 'package:image/image.dart' as img;

class SketchService {
  int _calculateAdaptiveThreshold(img.Image image) {
    int sum = 0;

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        sum += image.getPixel(x, y).r.toInt();
      }
    }

    final average = sum ~/ (image.width * image.height);

    return average;
  }

  img.Image _removeNoise(img.Image image, int threshold) {
    final result = img.Image.from(image);

    for (int y = 1; y < image.height - 1; y++) {
      for (int x = 1; x < image.width - 1; x++) {
        final pixel = image.getPixel(x, y);

        if (pixel.r <= threshold) continue;

        int neighbors = 0;

        for (int dy = -1; dy <= 1; dy++) {
          for (int dx = -1; dx <= 1; dx++) {
            if (dx == 0 && dy == 0) continue;

            final p = image.getPixel(x + dx, y + dy);

            if (p.r > threshold) {
              neighbors++;
            }
          }
        }

        // Nếu chỉ có rất ít điểm xung quanh thì coi là nhiễu
        if (neighbors < 2) {
          result.setPixelRgb(x, y, 0, 0, 0);
        }
      }
    }

    return result;
  }

  img.Image _thickenLines(img.Image image, int threshold, int thickness) {
    final result = img.Image.from(image);

    for (int y = thickness; y < image.height - thickness; y++) {
      for (int x = thickness; x < image.width - thickness; x++) {
        final pixel = image.getPixel(x, y);

        if (pixel.r > threshold) {
          for (int dy = -thickness; dy <= thickness; dy++) {
            for (int dx = -thickness; dx <= thickness; dx++) {
              result.setPixelRgb(x + dx, y + dy, 255, 255, 255);
            }
          }
        }
      }
    }

    return result;
  }

  Future<Uint8List> convertToSketch(
    Uint8List imageBytes, {
    int threshold = 120,
    bool invert = false,
    int lineThickness = 1,
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

    // ⭐ Lọc nhiễu
    image = _removeNoise(image, threshold);

    // ⭐ Làm dày nét
    image = _thickenLines(image, threshold, lineThickness);

    final adaptiveThreshold = _calculateAdaptiveThreshold(image);

    // Chuyển thành trắng đen
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);

        final isEdge = pixel.r > adaptiveThreshold;

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
