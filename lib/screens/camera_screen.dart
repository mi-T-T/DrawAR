import 'dart:ui' as ui;
import 'dart:io';
import 'dart:typed_data';
import 'dart:async';

import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:camera/camera.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/camera_service.dart';
import '../services/image_service.dart';
import '../services/sketch_service.dart';
import '../services/shared_image_service.dart';

import '../widgets/control_panel.dart';
import '../widgets/image_overlay.dart';
import '../widgets/gesture_overlay.dart';
import '../widgets/camera_buttons.dart';
import '../widgets/grid_overlay.dart';
import '../widgets/more_menu.dart';

import '../screens/ai_screen.dart';

final GlobalKey _captureKey = GlobalKey();

class CameraScreen extends StatefulWidget {
  final String? selectedImage; // 1. Khai báo biến lưu link/path ảnh ở đây

  const CameraScreen({
    super.key,
    this.selectedImage, // 2. Thêm vào constructor (dùng this.selectedImage)
  });

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

  bool _invertSketch = false;

  bool _showGrid = false;

  int _gridDivisions = 3;

  bool _isFlashOn = false;

  bool _isFlipped = false;

  bool _isLocked = false;

  bool _hideUI = false;
  Timer? _hideTimer;

  bool _hasMoreNotification = true;

  bool _isPanelExpanded = true;

  bool _imageExpanded = true;
  bool _sketchExpanded = false;

  double _opacity = 0.7;

  double _scale = 1.0;

  double _rotation = 0;

  double _threshold = 120;

  @override
  void initState() {
    super.initState();

    _initializeCamera();
    _loadSelectedImage();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();

    _hideTimer = Timer(const Duration(seconds: 5), () {
      if (!mounted) return;

      setState(() {
        _hideUI = true;
      });
    });
  }

  void _showUI() {
    if (_hideUI) {
      setState(() {
        _hideUI = false;
      });
    }

    _startHideTimer();
  }

  Future<void> _loadSelectedImage() async {
    if (widget.selectedImage == null) return;

    try {
      final byteData = await rootBundle.load(widget.selectedImage!);

      final tempDir = Directory.systemTemp;

      final file = File(
        '${tempDir.path}/selected_image_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      await file.writeAsBytes(byteData.buffer.asUint8List());

      _originalImage = file;

      if (_isSketchMode) {
        final bytes = await file.readAsBytes();

        _processedImage = await _sketchService.convertToSketch(
          bytes,
          threshold: _threshold.toInt(),
          invert: _invertSketch,
        );
      }

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('Lỗi tải ảnh asset: $e');
    }
  }

  Future<void> _initializeCamera() async {
    await _cameraService.initializeCamera();

    if (mounted) {
      setState(() {});
    }
    _startHideTimer();
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
        invert: _invertSketch,
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
      invert: _invertSketch,
    );

    setState(() {});
  }

  Future<void> _captureAndSave() async {
    try {
      // Ẩn toàn bộ UI
      setState(() {
        _hideUI = true;
      });

      // Chờ UI cập nhật
      await Future.delayed(const Duration(milliseconds: 150));

      final boundary =
          _captureKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) return;

      final pngBytes = byteData.buffer.asUint8List();

      final result = await ImageGallerySaverPlus.saveImage(
        pngBytes,
        quality: 100,
        name: "DrawAR_${DateTime.now().millisecondsSinceEpoch}",
      );

      // Hiện lại UI
      if (mounted) {
        setState(() {
          _hideUI = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Đã lưu ảnh vào thư viện")),
        );
      }
    } catch (e) {
      // Nếu lỗi cũng phải hiện lại UI
      if (mounted) {
        setState(() {
          _hideUI = false;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
      }
    }
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _transformationController.dispose();
    _hideTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraService.controller == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Camera")),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _showUI,
        child: RepaintBoundary(
          key: _captureKey,
          child: Stack(
            children: [
              /// Camera
              CameraPreview(_cameraService.controller!),

              if (_showGrid) GridOverlay(divisions: _gridDivisions),

              /// Ảnh overlay
              if (_originalImage != null)
                Center(
                  child: GestureOverlay(
                    transformationController: _transformationController,
                    doubleTapDetails: _doubleTapDetails,

                    isLocked: _isLocked,

                    onDoubleTapDown: (details) {
                      _doubleTapDetails = details;
                    },
                    child: ImageOverlay(
                      originalImage: _originalImage,
                      processedImage: _processedImage,
                      isSketchMode: _isSketchMode,
                      opacity: _opacity,
                      scale: _scale,
                      rotation: _rotation,
                      isFlipped: _isFlipped,
                    ),
                  ),
                ),

              if (!_hideUI)
                CameraButtons(
                  isFlashOn: _isFlashOn,

                  onFlashPressed: () async {
                    final enable = !_isFlashOn;

                    await _cameraService.setFlash(enable);

                    setState(() {
                      _isFlashOn = enable;
                    });
                  },

                  onResetPressed: () {
                    _transformationController.value = Matrix4.identity();

                    setState(() {
                      _rotation = 0;
                      _scale = 1.0;
                    });
                  },

                  onCapturePressed: _captureAndSave,

                  onGalleryPressed: _pickImage,
                  hasNotification: _hasMoreNotification,

                  onMorePressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => MoreMenu(
                        onAI: () async {
                          Navigator.pop(context);

                          // Xóa dữ liệu AI cũ trước khi mở
                          SharedImageService.clear();

                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AIScreen()),
                          );

                          // Nếu AI đã tạo ảnh thì lấy về Camera
                          if (SharedImageService.processedImage != null) {
                            setState(() {
                              _originalImage = SharedImageService.originalImage;
                              _processedImage =
                                  SharedImageService.processedImage;
                              _isSketchMode = true;
                            });

                            // Dọn bộ nhớ để lần sau không lấy lại ảnh cũ
                            SharedImageService.clear();
                          }
                        },

                        onClose: () {
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),

              /// Panel điều khiển
              if (!_hideUI)
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 20,
                  child: ControlPanel(
                    isSketchMode: _isSketchMode,
                    opacity: _opacity,
                    scale: _scale,
                    rotation: _rotation,
                    threshold: _threshold,
                    invert: _invertSketch,
                    isFlipped: _isFlipped,
                    isLocked: _isLocked,
                    showGrid: _showGrid,
                    gridDivisions: _gridDivisions,

                    isExpanded: _isPanelExpanded,
                    imageExpanded: _imageExpanded,
                    sketchExpanded: _sketchExpanded,

                    onToggleExpanded: () {
                      setState(() {
                        _isPanelExpanded = !_isPanelExpanded;
                      });
                    },

                    onToggleImage: () {
                      setState(() {
                        _imageExpanded = !_imageExpanded;
                      });
                    },

                    onToggleSketch: () {
                      setState(() {
                        _sketchExpanded = !_sketchExpanded;
                      });
                    },

                    onFlipPressed: () {
                      setState(() {
                        _isFlipped = !_isFlipped;
                      });
                    },

                    onLockPressed: () {
                      setState(() {
                        _isLocked = !_isLocked;
                      });
                    },

                    onGridChanged: (value) {
                      setState(() {
                        _showGrid = value;
                      });
                    },

                    onGridDivisionsChanged: (value) {
                      setState(() {
                        _gridDivisions = value.toInt();
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

                    onRotationChanged: (value) {
                      setState(() {
                        _rotation = value;
                      });
                    },

                    onThresholdChanged: (value) async {
                      setState(() {
                        _threshold = value;
                      });

                      await _updateSketch();
                    },

                    onInvertChanged: (value) async {
                      setState(() {
                        _invertSketch = value;
                      });

                      if (_originalImage != null && _isSketchMode) {
                        await _updateSketch();
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
