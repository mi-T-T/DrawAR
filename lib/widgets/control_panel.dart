import 'package:flutter/material.dart';

class ControlPanel extends StatelessWidget {
  final bool isSketchMode;
  final double opacity;
  final double scale;
  final double rotation;
  final double threshold;
  final bool isFlipped;
  final bool isLocked;
  final VoidCallback onFlipPressed;

  final bool isExpanded;
  final VoidCallback onToggleExpanded;

  final ValueChanged<bool> onSketchChanged;
  final ValueChanged<double> onOpacityChanged;
  final ValueChanged<double> onScaleChanged;
  final ValueChanged<double> onRotationChanged;
  final ValueChanged<double> onThresholdChanged;
  final VoidCallback onLockPressed;

  const ControlPanel({
    super.key,
    required this.isSketchMode,
    required this.opacity,
    required this.scale,
    required this.rotation,
    required this.threshold,
    required this.isFlipped,
    required this.isLocked,

    required this.isExpanded,
    required this.onToggleExpanded,

    required this.onFlipPressed,
    required this.onSketchChanged,
    required this.onOpacityChanged,
    required this.onScaleChanged,
    required this.onRotationChanged,
    required this.onThresholdChanged,
    required this.onLockPressed,
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

                  SwitchListTile(
                    title: const Text(
                      "Chế độ phác thảo",
                      style: TextStyle(color: Colors.white),
                    ),
                    value: isSketchMode,
                    onChanged: onSketchChanged,
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton.icon(
                    onPressed: onFlipPressed,
                    icon: const Icon(Icons.flip),
                    label: Text(isFlipped ? "Huỷ lật ảnh" : "Lật ảnh"),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton.icon(
                    onPressed: onLockPressed,
                    icon: Icon(isLocked ? Icons.lock : Icons.lock_open),
                    label: Text(isLocked ? "Mở khóa" : "Khóa ảnh"),
                  ),

                  const SizedBox(height: 10),

                  const Text("Độ mờ", style: TextStyle(color: Colors.white)),

                  Slider(
                    value: opacity,
                    min: 0.2,
                    max: 1,
                    divisions: 8,
                    label: (opacity * 100).toInt().toString(),
                    onChanged: onOpacityChanged,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Kích thước : ${scale.toStringAsFixed(1)}x",
                    style: const TextStyle(color: Colors.white),
                  ),

                  Slider(
                    value: scale,
                    min: 0.3,
                    max: 3,
                    divisions: 27,
                    label: scale.toStringAsFixed(1),
                    onChanged: onScaleChanged,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Xoay : ${rotation.toInt()}°",
                    style: const TextStyle(color: Colors.white),
                  ),

                  Slider(
                    value: rotation,
                    min: -180,
                    max: 180,
                    divisions: 360,
                    label: "${rotation.toInt()}°",
                    onChanged: onRotationChanged,
                  ),

                  if (isSketchMode) ...[
                    const SizedBox(height: 10),

                    Text(
                      "Độ chi tiết : ${threshold.toInt()}",
                      style: const TextStyle(color: Colors.white),
                    ),

                    Slider(
                      value: threshold,
                      min: 20,
                      max: 250,
                      divisions: 230,
                      label: threshold.toInt().toString(),
                      onChanged: onThresholdChanged,
                    ),
                  ],
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
