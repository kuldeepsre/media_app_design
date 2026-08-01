
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as imgLib;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../data/filter_catalog.dart';

class PixelCompositor {
  Future<imgLib.Image> composite({
    required File srcFile,
    required FxItem fx,
    required Face? faceMeta,
    required double strength,
  }) async {
    final Uint8List rawBytes = await srcFile.readAsBytes();
    imgLib.Image? decoded = imgLib.decodeImage(rawBytes);
    if (decoded == null) throw Exception('decode_fail');

    if (fx.cat == FilterCategory.colorGrade && fx.uid != 'raw') {
      decoded = _applyColorGrade(decoded, fx.uid, strength);
    }

    if (fx.needsFace && faceMeta != null && fx.asset.isNotEmpty) {
      decoded = await _compositeArAsset(decoded, fx, faceMeta, strength);
    } else if (fx.cat == FilterCategory.sticker2D && fx.asset.isNotEmpty) {
      decoded = await _compositeFreeAsset(decoded, fx, strength);
    }

    return decoded;
  }

  imgLib.Image _applyColorGrade(imgLib.Image base, String uid, double s) {
    s = s.clamp(0.0, 1.0).toDouble();
    if (uid == 'tokyo') {
      return imgLib.adjustColor(base, contrast: 10.0 * s, brightness: 5.0 * s, saturation: 10.0 * s);
    }
    if (uid == 'arctic') {
      var tmp = imgLib.adjustColor(base, saturation: -10.0 * s);
      return imgLib.adjustColor(tmp, hue: 20.0 * s);
    }
    if (uid == 'grain') {
      var tmp = imgLib.adjustColor(base, contrast: 15.0 * s);
      return tmp;
    }
    return base;
  }

  Future<imgLib.Image> _compositeArAsset(imgLib.Image base, FxItem fx, Face face, double strength) async {
    try {
      final ByteData assetData = await rootBundle.load(fx.asset);
      imgLib.Image? overlay = imgLib.decodeImage(assetData.buffer.asUint8List());
      if (overlay == null) return base;

      final box = face.boundingBox;

      double eyeDist = 100.0;
      final leftEye = face.landmarks[FaceLandmarkType.leftEye];
      final rightEye = face.landmarks[FaceLandmarkType.rightEye];
      if (leftEye != null && rightEye != null) {
        eyeDist = (leftEye.position.x - rightEye.position.x).abs().toDouble();
        if (eyeDist < 10) eyeDist = 100.0;
      }

      double scaleX = base.width / 720.0;
      double scaleY = base.height / 1280.0;

      int targetW = (box.width * scaleX * 1.6).toInt();
      if (fx.uid == 'ar_cyber_specs') {
        targetW = (eyeDist * scaleX * 3.2).toInt();
      }
      if (targetW <= 0) targetW = (base.width * 0.4).toInt();
      if (targetW > base.width) targetW = (base.width * 0.8).toInt();

      int targetH = (targetW * overlay.height / overlay.width).toInt();
      if (targetH <= 0) targetH = targetW;

      imgLib.Image resizedOverlay = imgLib.copyResize(overlay, width: targetW, height: targetH);

      int dx = (box.left * scaleX).toInt();
      int dy = (box.top * scaleY).toInt();

      if (fx.uid == 'ar_cyber_specs') {
        double eyeY = leftEye != null ? leftEye.position.y.toDouble() : box.top.toDouble();
        dy = (eyeY * scaleY - targetH * 0.4).toInt();
        dx = ((box.left + box.width * 0.1) * scaleX).toInt();
      }
      if (fx.uid == 'ar_neon_crown') {
        dy = (box.top * scaleY - targetH * 0.8).toInt();
      }
      if (fx.uid == 'ar_wolf') {
        dy = (box.top * scaleY - targetH * 0.3).toInt();
      }

      // FIXED: clamp returns num, cast to int with .toInt()
      int maxX = (base.width - targetW).clamp(0, base.width).toInt();
      int maxY = (base.height - targetH).clamp(0, base.height).toInt();
      dx = dx.clamp(0, maxX).toInt();
      dy = dy.clamp(0, maxY).toInt();

      return imgLib.compositeImage(base, resizedOverlay, dstX: dx, dstY: dy, blend: imgLib.BlendMode.alpha);
    } catch (e) {
      debugPrint('Composite error: \$e');
      return base;
    }
  }

  Future<imgLib.Image> _compositeFreeAsset(imgLib.Image base, FxItem fx, double strength) async {
    try {
      final ByteData data = await rootBundle.load(fx.asset);
      imgLib.Image? overlay = imgLib.decodeImage(data.buffer.asUint8List());
      if (overlay == null) return base;
      final resized = imgLib.copyResize(overlay, width: base.width);
      return imgLib.compositeImage(base, resized, blend: imgLib.BlendMode.alpha);
    } catch (e) {
      debugPrint('Free asset error: \$e');
      return base;
    }
  }
}
