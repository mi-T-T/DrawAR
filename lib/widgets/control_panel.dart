import 'package:flutter/material.dart';

class ControlPanel extends StatelessWidget {
  final bool isSketchMode;
  final double opacity;
  final double scale;
  final double threshold;
  final bool isFlipped;
  final VoidCallback onFlipPressed;

  final ValueChanged<bool> onSketchChanged;
  final ValueChanged<double> onOpacityChanged;
  final ValueChanged<double> onScaleChanged;
  final ValueChanged<double> onThresholdChanged;

  const ControlPanel({
    super.key,
    required this.isSketchMode,
    required this.opacity,
    required this.scale,
    required this.threshold,
    required this.isFlipped,
    required this.onFlipPressed,
    required this.onSketchChanged,
    required this.onOpacityChanged,
    required this.onScaleChanged,
    required this.onThresholdChanged,
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
      ),
    );
  }
}
