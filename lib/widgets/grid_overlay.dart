import 'package:flutter/material.dart';

class GridOverlay extends StatelessWidget {
  final int divisions;

  const GridOverlay({super.key, required this.divisions});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(size: Size.infinite, painter: GridPainter(divisions)),
    );
  }
}

class GridPainter extends CustomPainter {
  final int divisions;

  GridPainter(this.divisions);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.45)
      ..strokeWidth = 1;

    final dx = size.width / divisions;
    final dy = size.height / divisions;

    for (int i = 1; i < divisions; i++) {
      canvas.drawLine(Offset(dx * i, 0), Offset(dx * i, size.height), paint);

      canvas.drawLine(Offset(0, dy * i), Offset(size.width, dy * i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
