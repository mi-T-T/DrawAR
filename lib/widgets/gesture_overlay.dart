import 'package:flutter/material.dart';

class GestureOverlay extends StatelessWidget {
  final Widget child;
  final TransformationController transformationController;
  final TapDownDetails? doubleTapDetails;
  final Function(TapDownDetails) onDoubleTapDown;
  final bool isLocked;

  const GestureOverlay({
    super.key,
    required this.child,
    required this.transformationController,
    required this.doubleTapDetails,
    required this.onDoubleTapDown,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: GestureDetector(
        onDoubleTapDown: isLocked ? null : onDoubleTapDown,
        onDoubleTap: isLocked
            ? null
            : () {
                if (doubleTapDetails == null) return;

                final position = doubleTapDetails!.localPosition;

                transformationController.value = Matrix4.identity()
                  ..translate(-position.dx, -position.dy)
                  ..scale(2);
              },
        child: InteractiveViewer(
          transformationController: transformationController,
          minScale: 0.5,
          maxScale: 5,
          boundaryMargin: const EdgeInsets.all(500),
          constrained: false,
          panEnabled: !isLocked,
          scaleEnabled: !isLocked,
          child: Center(child: child),
        ),
      ),
    );
  }
}
