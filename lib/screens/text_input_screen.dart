import 'package:flutter/material.dart';

import 'text_camera_screen.dart';

class TextInputScreen extends StatefulWidget {
  const TextInputScreen({super.key});

  @override
  State<TextInputScreen> createState() => _TextInputScreenState();
}

class _TextInputScreenState extends State<TextInputScreen> {
  final TextEditingController _textController = TextEditingController();

  String _selectedFont = 'Roboto';

  final List<String> _fonts = [
    'Roboto',
    'RobotoSlab',
    'Lora',
    'Pacifico',
    'BebasNeue',
  ];

  @override
  void initState() {
    super.initState();

    _textController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _startDrawing() {
    final text = _textController.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập chữ trước'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TextCameraScreen(
          text: text,
          fontFamily: _selectedFont,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final previewText = _textController.text.isEmpty
        ? 'Preview'
        : _textController.text;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vẽ chữ'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // =========================
            // PREVIEW
            // =========================
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      previewText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: _selectedFont,
                        fontSize: 80,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // =========================
            // TEXT INPUT
            // =========================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _textController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Nhập chữ',
                  hintText: 'Ví dụ: DrawAR',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // =========================
            // FONT SELECTOR
            // =========================
            SizedBox(
              height: 100,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _fonts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final font = _fonts[index];
                  final selected = font == _selectedFont;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFont = font;
                      });
                    },
                    child: Container(
                      width: 130,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: selected
                            ? Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.15)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Aa',
                            style: TextStyle(
                              fontFamily: font,
                              fontSize: 32,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            font,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // =========================
            // START
            // =========================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _startDrawing,
                  child: const Text(
                    'Bắt đầu vẽ',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}