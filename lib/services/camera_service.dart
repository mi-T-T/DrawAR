import 'package:camera/camera.dart';

class CameraService {
  CameraController? _controller;

  CameraController? get controller => _controller;

  Future<void> initializeCamera() async {
    // Lấy danh sách camera trên thiết bị
    final cameras = await availableCameras();

    // Chọn camera sau nếu có
    final backCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    // Khởi tạo CameraController
    _controller = CameraController(
      backCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    // Khởi động camera
    await _controller!.initialize();
  }

  void dispose() {
    _controller?.dispose();
  }
}
