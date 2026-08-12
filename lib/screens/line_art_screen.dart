import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/sketch_service.dart';
import '../services/shared_image_service.dart';

class LineArtScreen extends StatefulWidget {
  const LineArtScreen({super.key});

  @override
  State<LineArtScreen> createState() => _LineArtScreenState();
}

class _LineArtScreenState extends State<LineArtScreen> {
  final SketchService _sketchService = SketchService();

  File? _selectedImage;
  bool _isProcessing = false;
  Uint8List? _processedImage;

  bool _invert = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final file = await picker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    setState(() {
      _selectedImage = File(file.path);
    });
  }

  Future<void> _generateSketch() async {
    if (_selectedImage == null) return;

    setState(() {
      _isProcessing = true;
    });

    final bytes = await _selectedImage!.readAsBytes();

    final result = await _sketchService.convertToSketch(
      bytes,
      threshold: 120,
      invert: _invert,
    );

    setState(() {
      _processedImage = result;
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chuyển nét vẽ"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Ảnh gốc
            SwitchListTile(
              title: const Text("Nền trắng"),
              value: _invert,
              onChanged: (value) async {
                setState(() {
                  _invert = value;
                });

                if (_processedImage != null) {
                  await _generateSketch();
                }
              },
            ),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Ảnh gốc",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey),
                ),
                child: _selectedImage == null
                    ? const Center(
                        child: Text(
                          "Chưa chọn ảnh",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            /// Kết quả
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Kết quả",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey),
                ),
                child: _isProcessing
                    ? const Center(child: CircularProgressIndicator())
                    : _processedImage == null
                    ? const Center(
                        child: Text(
                          "Chưa xử lý ảnh",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.memory(
                          _processedImage!,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.image),
                label: const Text("Chọn ảnh"),
                onPressed: _pickImage,
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.auto_fix_high),
                label: const Text("Chuyển nét vẽ"),
                onPressed: _selectedImage == null || _isProcessing
                    ? null
                    : _generateSketch,
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle),
                label: const Text("Dùng trong Camera"),
                onPressed: _processedImage == null
                    ? null
                    : () {
                        SharedImageService.originalImage = _selectedImage;

                        SharedImageService.processedImage = _processedImage;

                        SharedImageService.isSketchMode = true;

                        SharedImageService.invert = _invert;

                        Navigator.pop(context);
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
