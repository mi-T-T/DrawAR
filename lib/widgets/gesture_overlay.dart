import 'package:flutter/material.dart';

class GestureOverlay extends StatelessWidget {
  final Widget child;
  final bool isLocked;

  final GestureScaleStartCallback? onScaleStart;
  final GestureScaleUpdateCallback? onScaleUpdate;
  final GestureScaleEndCallback? onScaleEnd;

  const GestureOverlay({
    super.key,
    required this.child,
    required this.isLocked,
    this.onScaleStart,
    this.onScaleUpdate,
    this.onScaleEnd,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,

        onScaleStart: isLocked ? null : onScaleStart,

        onScaleUpdate: isLocked ? null : onScaleUpdate,

        onScaleEnd: isLocked ? null : onScaleEnd,

        child: child,
      ),
    );
  }
}
