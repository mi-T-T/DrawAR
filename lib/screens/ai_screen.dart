import 'package:flutter/material.dart';
import 'line_art_screen.dart';

class AIScreen extends StatefulWidget {
  const AIScreen({super.key});

  @override
  State<AIScreen> createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Hỗ trợ"), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Các công cụ AI",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          const Text(
            "⭐ Đề xuất",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Card(
            child: ListTile(
              leading: const Icon(Icons.auto_fix_high),
              title: const Text("Chuyển nét vẽ"),
              subtitle: const Text("Biến ảnh thành nét vẽ bằng AI"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LineArtScreen()),
                );
              },
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "🖼 Xử lý ảnh",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Card(
            child: ListTile(
              leading: const Icon(Icons.layers_clear),
              title: const Text("Xóa nền"),
              subtitle: const Text("AI tự động tách nền"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đang phát triển")),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.auto_awesome),
              title: const Text("Làm nét ảnh"),
              subtitle: const Text("Tăng chất lượng ảnh"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đang phát triển")),
                );
              },
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "✏️ Hỗ trợ vẽ",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Card(
            child: ListTile(
              leading: const Icon(Icons.center_focus_strong),
              title: const Text("Tự căn giữa"),
              subtitle: const Text("Đưa ảnh vào đúng vị trí"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đang phát triển")),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
