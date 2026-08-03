import 'package:flutter/material.dart';

class SketchPanel extends StatelessWidget {
  final bool isExpanded;
  final bool isSketchMode;
  final double threshold;

  final VoidCallback onToggle;

  final ValueChanged<bool> onSketchChanged;
  final ValueChanged<double> onThresholdChanged;

  const SketchPanel({
    super.key,
    required this.isExpanded,
    required this.isSketchMode,
    required this.threshold,
    required this.onToggle,
    required this.onSketchChanged,
    required this.onThresholdChanged,
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
      ],
    );
  }
}
