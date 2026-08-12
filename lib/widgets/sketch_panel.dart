import 'package:flutter/material.dart';

class SketchPanel extends StatelessWidget {
  final bool isExpanded;
  final bool isSketchMode;
  final double threshold;
  final bool invert;

  final VoidCallback onToggle;

  final ValueChanged<bool> onSketchChanged;
  final ValueChanged<double> onThresholdChanged;
  final ValueChanged<bool> onInvertChanged;

  const SketchPanel({
    super.key,
    required this.isExpanded,
    required this.isSketchMode,
    required this.threshold,
    required this.invert,
    required this.onToggle,
    required this.onSketchChanged,
    required this.onThresholdChanged,
    required this.onInvertChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),

        InkWell(
          onTap: onToggle,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  isExpanded ? "▼ Sketch" : "► Sketch",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        if (isExpanded) ...[
          const SizedBox(height: 10),

          SwitchListTile(
            title: const Text(
              "Chế độ phác thảo",
              style: TextStyle(color: Colors.white),
            ),
            value: isSketchMode,
            onChanged: onSketchChanged,
          ),

          if (isSketchMode) ...[
            const SizedBox(height: 10),

            SwitchListTile(
              title: const Text(
                "Nền trắng",
                style: TextStyle(color: Colors.white),
              ),
              value: invert,
              onChanged: onInvertChanged,
            ),

            const SizedBox(height: 10),

            Text(
              "Độ nhạy : ${threshold.toInt()}",
              style: const TextStyle(color: Colors.white),
            ),

            Slider(
              value: threshold,
              min: 20,
              max: 255,
              divisions: 255,
              label: threshold.toInt().toString(),
              onChanged: onThresholdChanged,
            ),
          ],
        ],
      ],
    );
  }
}
