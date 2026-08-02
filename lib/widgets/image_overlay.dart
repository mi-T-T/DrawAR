import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageOverlay extends StatelessWidget {
  final File? originalImage;
  final Uint8List? processedImage;
  final bool isSketchMode;
  final double opacity;
  final double scale;
  final bool isFlipped;

  const ImageOverlay({
    super.key,
    required this.originalImage,
    required this.processedImage,
    required this.isSketchMode,
    required this.opacity,
    required this.scale,
    required this.isFlipped,
  });

  @override
  Widget build(BuildContext context) {
    if (originalImage == null) {
      return const SizedBox();
    }

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..scale(isFlipped ? -1.0 : 1.0, 1.0),
      child: Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: opacity,
          child: isSketchMode
              ? (processedImage != null
                    ? Image.memory(processedImage!)
                    : const CircularProgressIndicator())
              : Image.file(originalImage!),
        ),
      ),
    );
  }
}
