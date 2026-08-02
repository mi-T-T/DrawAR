import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../services/camera_service.dart';
import '../services/image_service.dart';
import '../services/sketch_service.dart';
import '../widgets/control_panel.dart';
import '../widgets/image_overlay.dart';

import '../widgets/gesture_overlay.dart';

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
  TapDownDetails? _doubleTapDetails;

  File? _originalImage;

  Uint8List? _processedImage;

  bool _isSketchMode = false;

  bool _isFlipped = false;

  double _opacity = 0.7;

  double _scale = 1.0;

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
              child: GestureOverlay(
                transformationController: _transformationController,
                doubleTapDetails: _doubleTapDetails,
                onDoubleTapDown: (details) {
                  _doubleTapDetails = details;
                },
                child: ImageOverlay(
                  originalImage: _originalImage,
                  processedImage: _processedImage,
                  isSketchMode: _isSketchMode,
                  opacity: _opacity,
                  scale: _scale,
                  isFlipped: _isFlipped,
                ),
              ),
            ),

          /// Panel điều khiển
          Positioned(
            left: 10,
            right: 10,
            bottom: 20,
            child: ControlPanel(
              isSketchMode: _isSketchMode,
              opacity: _opacity,
              scale: _scale,
              threshold: _threshold,
              isFlipped: _isFlipped,

              onFlipPressed: () {
                setState(() {
                  _isFlipped = !_isFlipped;
                });
              },

              onSketchChanged: (value) async {
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

              onOpacityChanged: (value) {
                setState(() {
                  _opacity = value;
                });
              },

              onScaleChanged: (value) {
                setState(() {
                  _scale = value;
                });
              },

              onThresholdChanged: (value) async {
                setState(() {
                  _threshold = value;
                });

                await _updateSketch();
              },
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
