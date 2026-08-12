import 'package:flutter/material.dart';
import '../screens/camera_screen.dart';

class DrawingPage extends StatefulWidget {
  final String imagePath;

  const DrawingPage({super.key, required this.imagePath});

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  void _openARCamera() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(selectedImage: widget.imagePath),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),

        title: const Text(
          'Phác thảo AR',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Stack(
        children: [
          // Hiển thị ảnh mẫu
          Center(
            child: widget.imagePath.startsWith('http')
                ? Image.network(
                    widget.imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text(
                        'Không thể tải ảnh',
                        style: TextStyle(color: Colors.white),
                      );
                    },
                  )
                : Image.asset(widget.imagePath, fit: BoxFit.contain),
          ),

          // Nút Phác thảo AR
          Positioned(
            left: 20,
            right: 20,
            bottom: 30,
            child: ElevatedButton.icon(
              onPressed: _openARCamera,
              icon: const Icon(Icons.camera_alt_rounded),
              label: const Text(
                'Phác thảo AR',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF4081),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
