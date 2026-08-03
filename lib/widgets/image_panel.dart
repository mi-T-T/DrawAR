import 'package:flutter/material.dart';

class ImagePanel extends StatelessWidget {
  final bool isExpanded;
  final bool isFlipped;
  final bool isLocked;

  final bool showGrid;
  final int gridDivisions;
  final ValueChanged<double> onGridDivisionsChanged;
  final ValueChanged<bool> onGridChanged;

  final double opacity;
  final double scale;
  final double rotation;

  final VoidCallback onToggle;
  final VoidCallback onFlipPressed;
  final VoidCallback onLockPressed;

  final ValueChanged<double> onOpacityChanged;
  final ValueChanged<double> onScaleChanged;
  final ValueChanged<double> onRotationChanged;

  const ImagePanel({
    super.key,
    required this.isExpanded,
    required this.isFlipped,
    required this.isLocked,

    required this.showGrid,
    required this.onGridChanged,
    required this.gridDivisions,
    required this.onGridDivisionsChanged,

    required this.opacity,
    required this.scale,
    required this.rotation,
    required this.onToggle,
    required this.onFlipPressed,
    required this.onLockPressed,
    required this.onOpacityChanged,
    required this.onScaleChanged,
    required this.onRotationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onToggle,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  isExpanded ? "▼ Ảnh" : "► Ảnh",
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
            title: const Text("Lưới", style: TextStyle(color: Colors.white)),
            value: showGrid,
            onChanged: onGridChanged,
          ),

          if (showGrid) ...[
            const SizedBox(height: 10),

            Text(
              "Mật độ lưới : ${gridDivisions} × ${gridDivisions}",
              style: const TextStyle(color: Colors.white),
            ),

            Slider(
              value: gridDivisions.toDouble(),
              min: 2,
              max: 8,
              divisions: 6,
              label: "${gridDivisions}x${gridDivisions}",
              onChanged: onGridDivisionsChanged,
            ),
          ],

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
        ],
      ],
    );
  }
}
