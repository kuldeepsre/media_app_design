
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';

class FaceScanner {
  final FaceDetector _det = FaceDetector(options: FaceDetectorOptions(enableLandmarks: true, enableContours: true, performanceMode: FaceDetectorMode.fast));
  Future<List<Face>> scanCameraImage(CameraImage img, CameraDescription cam) async {
    final WriteBuffer buf = WriteBuffer();
    for (Plane p in img.planes) buf.putUint8List(p.bytes);
    final bytes = buf.done().buffer.asUint8List();
    final meta = InputImageMetadata(size: Size(img.width.toDouble(), img.height.toDouble()), rotation: InputImageRotationValue.fromRawValue(cam.sensorOrientation) ?? InputImageRotation.rotation0deg, format: InputImageFormatValue.fromRawValue(img.format.raw) ?? InputImageFormat.nv21, bytesPerRow: img.planes[0].bytesPerRow);
    return await _det.processImage(InputImage.fromBytes(bytes: bytes, metadata: meta));
  }
  Future<List<Face>> scanFile(String path) async => await _det.processImage(InputImage.fromFilePath(path));
  void dispose() => _det.close();
}
