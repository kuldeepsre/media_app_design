
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../engine/pixel_compositor.dart';
import '../core/face_scanner.dart';

class CamBrain extends ChangeNotifier {
  CameraController? ctrl;
  List<CameraDescription> cams = [];
  bool ready = false;
  Face? faceNow;
  bool _scanning = false;
  bool flashOn = false;
  bool recording = false;
  double zoom = 1.0;

  final FaceScanner _scanner = FaceScanner();

  Future<void> boot() async {
    cams = await availableCameras();
    if (cams.isEmpty) return;
    final front = cams.firstWhere((c) => c.lensDirection == CameraLensDirection.front, orElse: () => cams.first);
    ctrl = CameraController(front, ResolutionPreset.veryHigh, enableAudio: true, imageFormatGroup: ImageFormatGroup.nv21);
    await ctrl!.initialize();
    ready = true;
    notifyListeners();
    _listenFace();
  }

  void _listenFace() {
    ctrl!.startImageStream((img) async {
      if (_scanning) return;
      _scanning = true;
      try {
        final faces = await _scanner.scanCameraImage(img, ctrl!.description);
        faceNow = faces.isNotEmpty ? faces.first : null;
        notifyListeners();
      } finally {
        _scanning = false;
      }
    });
  }

  Future<void> toggleFlash() async {
    flashOn = !flashOn;
    await ctrl!.setFlashMode(flashOn ? FlashMode.torch : FlashMode.off);
    notifyListeners();
  }

  Future<void> flip() async {
    final isFront = ctrl!.description.lensDirection == CameraLensDirection.front;
    final next = cams.firstWhere((c) => c.lensDirection == (isFront ? CameraLensDirection.back : CameraLensDirection.front));
    await ctrl!.dispose();
    ctrl = CameraController(next, ResolutionPreset.veryHigh, enableAudio: true);
    await ctrl!.initialize();
    notifyListeners();
    _listenFace();
  }

  Future<XFile> snap() async {
    return await ctrl!.takePicture();
  }

  @override
  void dispose() {
    ctrl?.dispose();
    _scanner.dispose();
    super.dispose();
  }
}
