
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../logic/fx_brain.dart';
import '../logic/render_brain.dart';
import '../core/face_scanner.dart';
import '../core/app_colors.dart';
import 'components/fx_strip.dart';
import 'preview_final.dart';

class EditPhoto extends StatefulWidget {
  final String path;
  const EditPhoto({super.key, required this.path});
  @override
  State<EditPhoto> createState() => _EditPhotoState();
}

class _EditPhotoState extends State<EditPhoto> {
  Face? face;
  File? preview;
  bool showOriginal = false;
  final scanner = FaceScanner();

  @override
  void initState() {
    super.initState();
    _scan();
    preview = File(widget.path);
  }

  Future<void> _scan() async {
    final faces = await scanner.scanFile(widget.path);
    if (faces.isNotEmpty) setState(() => face = faces.first);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<FxBrain, RenderBrain>(
      builder: (_, fxBrain, render, __) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.black, title: Text('EDIT PHOTO', style: TextStyle(color: Colors.white, fontSize: 13, letterSpacing: 2)), actions: [
            if (!render.busy)
              TextButton(
                onPressed: () async {
                  final out = await render.renderPhoto(input: File(widget.path), fx: fxBrain.activeFx, face: face, power: fxBrain.power);
                  if (!mounted) return;
                  Navigator.push(context, MaterialPageRoute(builder: (_) => PreviewFinal(file: out, isVideo: false, originalPath: widget.path)));
                },
                child: Text('RENDER', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
              ),
          ]),
          body: Stack(children: [
            Center(child: showOriginal ? Image.file(File(widget.path)) : (preview != null ? Image.file(preview!) : Image.file(File(widget.path)))),
            if (render.busy)
              Container(color: Colors.black87, child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [CircularProgressIndicator(color: AppColors.accent), SizedBox(height: 12), Text(render.log, style: TextStyle(color: Colors.white, fontSize: 12)), SizedBox(height: 6), Text('${(render.prog*100).toInt()}%', style: TextStyle(color: Colors.white54)), SizedBox(height: 8), Text('Decode → Render → Encode', style: TextStyle(color: AppColors.accent, fontSize: 10, letterSpacing: 2))]))),
            Positioned(top: 16, left: 16, child: GestureDetector(onTap: () => setState(() => showOriginal = !showOriginal), child: Container(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white24)), child: Text(showOriginal ? 'Showing Original' : 'Showing Preview', style: TextStyle(color: Colors.white, fontSize: 10))))),
            Positioned(bottom: 0, left: 0, right: 0, child: FxStrip()),
          ]),
        );
      },
    );
  }
}
