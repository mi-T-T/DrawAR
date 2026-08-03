import 'package:flutter/material.dart';

class CameraButtons extends StatelessWidget {
  final bool isFlashOn;
  final VoidCallback onFlashPressed;

  final VoidCallback onResetPressed;

  final VoidCallback onCapturePressed;

  final VoidCallback onGalleryPressed;

  final VoidCallback onMorePressed;

  final bool hasNotification;

  const CameraButtons({
    super.key,
    required this.isFlashOn,
    required this.onFlashPressed,
    required this.onResetPressed,
    required this.onCapturePressed,
    required this.onGalleryPressed,
    required this.onMorePressed,
    required this.hasNotification,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                tooltip: "Flash",
                onPressed: onFlashPressed,
                icon: Icon(
                  isFlashOn ? Icons.flash_on : Icons.flash_off,
                  color: Colors.white,
                ),
              ),

              IconButton(
                tooltip: "Chụp",
                onPressed: onCapturePressed,
                icon: const Icon(Icons.camera_alt, color: Colors.white),
              ),

              IconButton(
                tooltip: "Thư viện",
                onPressed: onGalleryPressed,
                icon: const Icon(Icons.image, color: Colors.white),
              ),

              IconButton(
                tooltip: "Reset",
                onPressed: onResetPressed,
                icon: const Icon(Icons.refresh, color: Colors.white),
              ),

              const Spacer(),

              Stack(
                children: [
                  IconButton(
                    tooltip: "Thêm",
                    onPressed: onMorePressed,
                    icon: const Icon(Icons.menu, color: Colors.white),
                  ),

                  if (hasNotification)
                    const Positioned(
                      right: 10,
                      top: 10,
                      child: CircleAvatar(
                        radius: 4,
                        backgroundColor: Colors.red,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
