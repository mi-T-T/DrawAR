import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageOverlay extends StatelessWidget {
  final File? originalImage;
  final Uint8List? processedImage;
  final bool isSketchMode;
  final double opacity;
  final double scale;
  final double rotation;
  final bool isFlipped;
  final Offset position;

  const ImageOverlay({
    super.key,
    required this.originalImage,
    required this.processedImage,
    required this.isSketchMode,
    required this.opacity,
    required this.scale,
    required this.rotation,
    required this.isFlipped,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    if (originalImage == null) {
      return const SizedBox();
    }

    return Transform.translate(
      offset: position,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..scale(isFlipped ? -scale : scale, scale)
          ..rotateZ(rotation * 3.1415926535 / 180),
        child: Opacity(
          opacity: opacity,
          child: isSketchMode
              ? (processedImage != null
                    ? Image.memory(processedImage!, fit: BoxFit.contain)
                    : const CircularProgressIndicator())
              : Image.file(originalImage!, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
