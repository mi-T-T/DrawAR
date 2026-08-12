import 'package:flutter/material.dart';
import 'image_panel.dart';
import 'sketch_panel.dart';

class ControlPanel extends StatelessWidget {
  final bool isSketchMode;
  final double opacity;
  final double scale;
  final double rotation;
  final double threshold;
  final bool invert;
  final bool isFlipped;
  final bool isLocked;
  final bool imageExpanded;
  final bool sketchExpanded;
  final VoidCallback onFlipPressed;
  final bool showGrid;
  final int gridDivisions;
  final ValueChanged<double> onGridDivisionsChanged;

  final bool isExpanded;
  final VoidCallback onToggleExpanded;

  final ValueChanged<bool> onSketchChanged;
  final ValueChanged<double> onOpacityChanged;
  final ValueChanged<double> onScaleChanged;
  final ValueChanged<double> onRotationChanged;
  final ValueChanged<double> onThresholdChanged;
  final ValueChanged<bool> onInvertChanged;
  final VoidCallback onToggleImage;
  final VoidCallback onToggleSketch;
  final VoidCallback onLockPressed;
  final ValueChanged<bool> onGridChanged;

  const ControlPanel({
    super.key,
    required this.isSketchMode,
    required this.opacity,
    required this.scale,
    required this.rotation,
    required this.threshold,
    required this.invert,
    required this.isFlipped,
    required this.isLocked,
    required this.imageExpanded,
    required this.sketchExpanded,
    required this.showGrid,
    required this.gridDivisions,
    required this.onGridDivisionsChanged,

    required this.isExpanded,
    required this.onToggleExpanded,

    required this.onFlipPressed,
    required this.onSketchChanged,
    required this.onOpacityChanged,
    required this.onScaleChanged,
    required this.onRotationChanged,
    required this.onThresholdChanged,
    required this.onInvertChanged,
    required this.onLockPressed,
    required this.onToggleImage,
    required this.onToggleSketch,
    required this.onGridChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black54,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Thanh tiêu đề
            InkWell(
              onTap: onToggleExpanded,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        isExpanded ? "▼ Công cụ" : "▲ Công cụ",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            AnimatedCrossFade(
              duration: const Duration(milliseconds: 250),
              crossFadeState: isExpanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,

              firstChild: Column(
                children: [
                  const SizedBox(height: 15),

                  ImagePanel(
                    isExpanded: imageExpanded,
                    isFlipped: isFlipped,
                    isLocked: isLocked,

                    showGrid: showGrid,
                    onGridChanged: onGridChanged,

                    gridDivisions: gridDivisions,
                    onGridDivisionsChanged: onGridDivisionsChanged,

                    opacity: opacity,
                    scale: scale,
                    rotation: rotation,

                    onToggle: onToggleImage,
                    onFlipPressed: onFlipPressed,
                    onLockPressed: onLockPressed,

                    onOpacityChanged: onOpacityChanged,
                    onScaleChanged: onScaleChanged,
                    onRotationChanged: onRotationChanged,
                  ),
                  const SizedBox(height: 15),

                  SketchPanel(
                    isExpanded: sketchExpanded,
                    isSketchMode: isSketchMode,
                    threshold: threshold,
                    invert: invert,

                    onToggle: onToggleSketch,
                    onSketchChanged: onSketchChanged,
                    onThresholdChanged: onThresholdChanged,
                    onInvertChanged: onInvertChanged,
                  ),
                ],
              ),

              secondChild: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
