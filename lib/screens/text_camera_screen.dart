import 'dart:async';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

import '../services/camera_service.dart';
import '../widgets/grid_overlay.dart';

final GlobalKey _textCaptureKey = GlobalKey();

class TextCameraScreen extends StatefulWidget {
  final String text;
  final String fontFamily;

  const TextCameraScreen({
    super.key,
    required this.text,
    required this.fontFamily,
  });

  @override
  State<TextCameraScreen> createState() => _TextCameraScreenState();
}

class _TextCameraScreenState extends State<TextCameraScreen> {
  final CameraService _cameraService = CameraService();

  final TransformationController _transformationController =
  TransformationController();

  bool _isFlashOn = false;
  bool _isLocked = false;

  bool _showGrid = false;
  int _gridDivisions = 3;

  bool _hideUI = false;
  Timer? _hideTimer;

  double _opacity = 0.8;

  Color _textColor = Colors.white;

  double _fontSize = 80;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    await _cameraService.initializeCamera();

    if (!mounted) return;

    setState(() {});

    _startHideTimer();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();

    _hideTimer = Timer(
      const Duration(seconds: 5),
          () {
        if (!mounted) return;

        setState(() {
          _hideUI = true;
        });
      },
    );
  }

  void _showUI() {
    if (!mounted) return;

    setState(() {
      _hideUI = false;
    });

    _startHideTimer();
  }

  Future<void> _captureAndSave() async {
    try {
      setState(() {
        _hideUI = true;
      });

      await Future.delayed(
        const Duration(milliseconds: 150),
      );

      final boundary = _textCaptureKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      final ui.Image image = await boundary.toImage(
        pixelRatio: 3.0,
      );

      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        throw Exception('Không thể tạo ảnh');
      }

      final pngBytes = byteData.buffer.asUint8List();

      await ImageGallerySaverPlus.saveImage(
        pngBytes,
        quality: 100,
        name: 'DrawAR_Text_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (!mounted) return;

      setState(() {
        _hideUI = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Đã lưu ảnh vào thư viện'),
        ),
      );

      _startHideTimer();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _hideUI = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: $e'),
        ),
      );
    }
  }

  Future<void> _toggleFlash() async {
    final enable = !_isFlashOn;

    await _cameraService.setFlash(enable);

    if (!mounted) return;

    setState(() {
      _isFlashOn = enable;
    });
  }

  void _resetText() {
    _transformationController.value = Matrix4.identity();

    setState(() {
      _fontSize = 80;
      _opacity = 0.8;
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _cameraService.dispose();
    _transformationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraService.controller == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _showUI,
        onPanDown: (_) => _showUI(),
        child: RepaintBoundary(
          key: _textCaptureKey,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ========================================
              // CAMERA
              // ========================================
              CameraPreview(
                _cameraService.controller!,
              ),

              // ========================================
              // GRID
              // ========================================
              if (_showGrid)
                GridOverlay(
                  divisions: _gridDivisions,
                ),

              // ========================================
              // TEXT
              // ========================================
              Center(
                child: InteractiveViewer(
                  transformationController:
                  _transformationController,
                  panEnabled: !_isLocked,
                  scaleEnabled: !_isLocked,
                  minScale: 0.3,
                  maxScale: 5.0,
                  child: Opacity(
                    opacity: _opacity,
                    child: Text(
                      widget.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: widget.fontFamily,
                        fontSize: _fontSize,
                        color: _textColor,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),

              // ========================================
              // TOP BAR
              // ========================================
              if (!_hideUI)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  left: 10,
                  right: 10,
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      _CircleButton(
                        icon: Icons.arrow_back,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),

                      _CircleButton(
                        icon: _isLocked
                            ? Icons.lock
                            : Icons.lock_open,
                        onPressed: () {
                          setState(() {
                            _isLocked = !_isLocked;
                          });
                        },
                      ),
                    ],
                  ),
                ),

              // ========================================
              // CAMERA CONTROLS
              // ========================================
              if (!_hideUI)
                Positioned(
                  right: 16,
                  top: MediaQuery.of(context).size.height * 0.35,
                  child: Column(
                    children: [
                      _CircleButton(
                        icon: _isFlashOn
                            ? Icons.flash_on
                            : Icons.flash_off,
                        onPressed: _toggleFlash,
                      ),

                      const SizedBox(height: 12),

                      _CircleButton(
                        icon: Icons.refresh,
                        onPressed: _resetText,
                      ),
                    ],
                  ),
                ),

              // ========================================
              // BOTTOM PANEL
              // ========================================
              if (!_hideUI)
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 20,
                  child: _TextControlPanel(
                    opacity: _opacity,
                    fontSize: _fontSize,
                    showGrid: _showGrid,
                    gridDivisions: _gridDivisions,
                    isLocked: _isLocked,
                    textColor: _textColor,

                    onOpacityChanged: (value) {
                      setState(() {
                        _opacity = value;
                      });
                    },

                    onFontSizeChanged: (value) {
                      setState(() {
                        _fontSize = value;
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

                    onColorChanged: (color) {
                      setState(() {
                        _textColor = color;
                      });
                    },

                    onLockChanged: (value) {
                      setState(() {
                        _isLocked = value;
                      });
                    },

                    onCapture: _captureAndSave,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _CircleButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.55),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _TextControlPanel extends StatelessWidget {
  final double opacity;
  final double fontSize;

  final bool showGrid;
  final int gridDivisions;
  final bool isLocked;

  final Color textColor;

  final ValueChanged<double> onOpacityChanged;
  final ValueChanged<double> onFontSizeChanged;

  final ValueChanged<bool> onGridChanged;
  final ValueChanged<double> onGridDivisionsChanged;

  final ValueChanged<Color> onColorChanged;
  final ValueChanged<bool> onLockChanged;

  final VoidCallback onCapture;

  const _TextControlPanel({
    required this.opacity,
    required this.fontSize,
    required this.showGrid,
    required this.gridDivisions,
    required this.isLocked,
    required this.textColor,
    required this.onOpacityChanged,
    required this.onFontSizeChanged,
    required this.onGridChanged,
    required this.onGridDivisionsChanged,
    required this.onColorChanged,
    required this.onLockChanged,
    required this.onCapture,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.75),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // -------------------------
          // FONT SIZE
          // -------------------------
          Row(
            children: [
              const Icon(
                Icons.text_fields,
                color: Colors.white,
              ),
              Expanded(
                child: Slider(
                  min: 20,
                  max: 180,
                  value: fontSize,
                  onChanged: onFontSizeChanged,
                ),
              ),
              Text(
                fontSize.toInt().toString(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),

          // -------------------------
          // OPACITY
          // -------------------------
          Row(
            children: [
              const Icon(
                Icons.opacity,
                color: Colors.white,
              ),
              Expanded(
                child: Slider(
                  min: 0.1,
                  max: 1.0,
                  value: opacity,
                  onChanged: onOpacityChanged,
                ),
              ),
              Text(
                '${(opacity * 100).toInt()}%',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),

          // -------------------------
          // GRID
          // -------------------------
          Row(
            children: [
              const Icon(
                Icons.grid_4x4,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Lưới',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Switch(
                value: showGrid,
                onChanged: onGridChanged,
              ),
            ],
          ),

          if (showGrid)
            Row(
              children: [
                const Text(
                  'Chia:',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Slider(
                    min: 2,
                    max: 10,
                    divisions: 8,
                    value: gridDivisions.toDouble(),
                    onChanged: onGridDivisionsChanged,
                  ),
                ),
                Text(
                  '$gridDivisions',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),

          // -------------------------
          // COLORS
          // -------------------------
          Row(
            children: [
              const Text(
                'Màu:',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),

              _ColorButton(
                color: Colors.white,
                selected: textColor == Colors.white,
                onTap: () => onColorChanged(Colors.white),
              ),

              _ColorButton(
                color: Colors.black,
                selected: textColor == Colors.black,
                onTap: () => onColorChanged(Colors.black),
              ),

              _ColorButton(
                color: Colors.red,
                selected: textColor == Colors.red,
                onTap: () => onColorChanged(Colors.red),
              ),

              _ColorButton(
                color: Colors.yellow,
                selected: textColor == Colors.yellow,
                onTap: () => onColorChanged(Colors.yellow),
              ),

              _ColorButton(
                color: Colors.blue,
                selected: textColor == Colors.blue,
                onTap: () => onColorChanged(Colors.blue),
              ),

              const Spacer(),

              IconButton(
                onPressed: () {
                  onLockChanged(!isLocked);
                },
                icon: Icon(
                  isLocked
                      ? Icons.lock
                      : Icons.lock_open,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // -------------------------
          // CAPTURE
          // -------------------------
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: onCapture,
              icon: const Icon(Icons.camera_alt),
              label: const Text(
                'Chụp & lưu',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorButton extends StatelessWidget {
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _ColorButton({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected
                ? Colors.orange
                : Colors.white,
            width: selected ? 3 : 1,
          ),
        ),
      ),
    );
  }
}