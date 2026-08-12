import 'package:flutter/material.dart';
import 'dart:math' as math;

class GestureOverlay extends StatefulWidget {
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
  State<GestureOverlay> createState() => _GestureOverlayState();
}

class _GestureOverlayState extends State<GestureOverlay> {
  Offset _translation = Offset.zero;

  double _scale = 1.0;

  double _rotation = 0.0;

  Offset _startFocalPoint = Offset.zero;

  double _startScale = 1.0;

  double _startRotation = 0.0;

  Offset _startTranslation = Offset.zero;

  @override
  void initState() {
    super.initState();

    _readInitialMatrix();
  }

  void _readInitialMatrix() {
    final matrix = widget.transformationController.value;

    _translation = Offset(matrix.storage[12], matrix.storage[13]);
  }

  void _updateMatrix() {
    final matrix = Matrix4.identity();

    matrix.translate(_translation.dx, _translation.dy);

    matrix.rotateZ(_rotation);

    matrix.scale(_scale);

    widget.transformationController.value = matrix;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,

        // ==========================================
        // DOUBLE TAP
        // ==========================================
        onDoubleTapDown: widget.isLocked ? null : widget.onDoubleTapDown,

        onDoubleTap: widget.isLocked
            ? null
            : () {
                if (widget.doubleTapDetails == null) {
                  return;
                }

                if (_scale < 2.0) {
                  _scale = 2.0;
                } else {
                  _scale = 1.0;
                }

                _updateMatrix();

                setState(() {});
              },

        // ==========================================
        // BẮT ĐẦU GESTURE
        // ==========================================
        onScaleStart: widget.isLocked
            ? null
            : (details) {
                _startFocalPoint = details.focalPoint;

                _startScale = _scale;

                _startRotation = _rotation;

                _startTranslation = _translation;
              },

        // ==========================================
        // 1 NGÓN + 2 NGÓN
        // ==========================================
        onScaleUpdate: widget.isLocked
            ? null
            : (details) {
                // ------------------------------
                // 1. DI CHUYỂN
                // ------------------------------

                final delta = details.focalPoint - _startFocalPoint;

                _translation = _startTranslation + delta;

                // ------------------------------
                // 2. ZOOM
                // ------------------------------

                _scale = (_startScale * details.scale).clamp(0.5, 5.0);

                // ------------------------------
                // 3. XOAY
                // ------------------------------

                _rotation = _startRotation + details.rotation;

                // ------------------------------
                // CẬP NHẬT MATRIX
                // ------------------------------

                _updateMatrix();
              },

        onScaleEnd: widget.isLocked
            ? null
            : (_) {
                _startFocalPoint = Offset.zero;
              },

        child: Center(child: widget.child),
      ),
    );
  }
}
