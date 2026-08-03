import 'package:flutter/material.dart';
import '../screens/ai_screen.dart';

class MoreMenu extends StatelessWidget {
  final VoidCallback onAI;
  final VoidCallback onClose;

  const MoreMenu({super.key, required this.onAI, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Công cụ nâng cao",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.smart_toy, color: Colors.cyan),

              title: const Text(
                "AI Hỗ trợ",
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                "Line Art, Xóa nền, Làm nét...",
                style: TextStyle(color: Colors.white54),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white54,
                size: 18,
              ),
              onTap: onAI,
            ),

            const Divider(color: Colors.white24),

            ListTile(
              leading: const Icon(Icons.grid_4x4, color: Colors.orange),
              title: const Text(
                "Lưới nâng cao",
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                "Sẽ phát triển sau",
                style: TextStyle(color: Colors.white54),
              ),
              onTap: () {},
            ),

            const Divider(color: Colors.white24),

            ListTile(
              leading: const Icon(Icons.settings, color: Colors.green),
              title: const Text(
                "Cài đặt",
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                "Sẽ phát triển sau",
                style: TextStyle(color: Colors.white54),
              ),
              onTap: () {},
            ),

            const Divider(color: Colors.white24),

            ListTile(
              leading: const Icon(Icons.close, color: Colors.redAccent),
              title: const Text("Đóng", style: TextStyle(color: Colors.white)),
              onTap: onClose,
            ),
          ],
        ),
      ),
    );
  }
}
