import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../services/camera_service.dart';
import '../services/image_service.dart';
import '../services/sketch_service.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final CameraService _cameraService = CameraService();
  final ImageService _imageService = ImageService();
  final SketchService _sketchService = SketchService();

  final TransformationController _transformationController =
      TransformationController();

  File? _originalImage;

  Uint8List? _processedImage;

  bool _isSketchMode = false;

  double _opacity = 0.7;

  double _threshold = 120;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    await _cameraService.initializeCamera();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _pickImage() async {
    final image = await _imageService.pickImage();

    if (image == null) return;

    _originalImage = image;

    if (_isSketchMode) {
      final bytes = await image.readAsBytes();

      _processedImage = await _sketchService.convertToSketch(
        bytes,
        threshold: _threshold.toInt(),
      );
    } else {
      _processedImage = null;
    }

    setState(() {});
  }

  Future<void> _updateSketch() async {
    if (_originalImage == null) return;

    final bytes = await _originalImage!.readAsBytes();

    _processedImage = await _sketchService.convertToSketch(
      bytes,
      threshold: _threshold.toInt(),
    );

    setState(() {});
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraService.controller == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Camera")),
      body: Stack(
        children: [
          /// Camera
          CameraPreview(_cameraService.controller!),

          /// Ảnh overlay
          if (_originalImage != null)
            Center(
              child: InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.2,
                maxScale: 8,
                panEnabled: true,
                scaleEnabled: true,
                child: Opacity(
                  opacity: _opacity,
                  child: _isSketchMode
                      ? (_processedImage != null
                            ? Image.memory(_processedImage!)
                            : const Center(child: CircularProgressIndicator()))
                      : Image.file(_originalImage!),
                ),
              ),
            ),

          /// Panel điều khiển
          Positioned(
            left: 10,
            right: 10,
            bottom: 20,
            child: Card(
              color: Colors.black54,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Sketch ON/OFF
                    SwitchListTile(
                      title: const Text(
                        "Sketch Mode",
                        style: TextStyle(color: Colors.white),
                      ),
                      value: _isSketchMode,
                      onChanged: (value) async {
                        setState(() {
                          _isSketchMode = value;
                        });

                        if (_originalImage == null) return;

                        if (_isSketchMode) {
                          await _updateSketch();
                        } else {
                          setState(() {
                            _processedImage = null;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Opacity",
                      style: TextStyle(color: Colors.white),
                    ),

                    Slider(
                      value: _opacity,
                      min: 0.2,
                      max: 1,
                      divisions: 8,
                      label: (_opacity * 100).toInt().toString(),
                      onChanged: (value) {
                        setState(() {
                          _opacity = value;
                        });
                      },
                    ),

                    if (_isSketchMode) ...[
                      const SizedBox(height: 10),

                      Text(
                        "Edge Threshold : ${_threshold.toInt()}",
                        style: const TextStyle(color: Colors.white),
                      ),

                      Slider(
                        value: _threshold,
                        min: 20,
                        max: 250,
                        divisions: 230,
                        label: _threshold.toInt().toString(),
                        onChanged: (value) async {
                          setState(() {
                            _threshold = value;
                          });

                          await _updateSketch();
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 15,
            right: 15,
            child: FloatingActionButton.small(
              heroTag: "reset",
              onPressed: () {
                _transformationController.value = Matrix4.identity();
              },
              child: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        child: const Icon(Icons.photo),
      ),
    );
  }
}
