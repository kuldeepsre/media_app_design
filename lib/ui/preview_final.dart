
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import '../logic/render_brain.dart';
import '../core/app_colors.dart';

class PreviewFinal extends StatefulWidget {
  final File file;
  final bool isVideo;
  final String originalPath;
  const PreviewFinal({super.key, required this.file, required this.isVideo, required this.originalPath});
  @override
  State<PreviewFinal> createState() => _PreviewFinalState();
}

class _PreviewFinalState extends State<PreviewFinal> {
  VideoPlayerController? _vc;
  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      _vc = VideoPlayerController.file(widget.file)..initialize().then((_) { setState(() {}); _vc!.setLooping(true); _vc!.play(); });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, title: Text('NEW FILE CREATED', style: TextStyle(color: AppColors.accent, fontSize: 11, letterSpacing: 2))),
      body: Column(children: [
        Expanded(child: Center(child: widget.isVideo ? (_vc != null && _vc!.value.isInitialized ? AspectRatio(aspectRatio: _vc!.value.aspectRatio, child: VideoPlayer(_vc!)) : CircularProgressIndicator()) : Image.file(widget.file))),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Icon(Icons.check_circle, color: AppColors.accent, size: 16), SizedBox(width: 6), Text('Proof of Workflow', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))]),
            SizedBox(height: 10),
            _row('Original:', widget.originalPath.split('/').last),
            _row('Filtered (NEW):', widget.file.path.split('/').last),
            _row('Method:', 'Decode → Render → Encode (pixels burned)'),
            _row('FFmpeg:', 'NOT USED - image + MediaCodec'),
            SizedBox(height: 16),
            SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: Colors.black), onPressed: () async { final ok = await context.read<RenderBrain>().save(); if (!mounted) return; ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Saved to Gallery!' : 'Save failed'))); }, child: Text('SAVE TO GALLERY', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)))),
          ]),
        ),
      ]),
    );
  }

  Widget _row(String k, String v) => Padding(padding: EdgeInsets.only(bottom: 4), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 110, child: Text(k, style: TextStyle(color: Colors.white38, fontSize: 10))), Expanded(child: Text(v, style: TextStyle(color: Colors.white70, fontSize: 10)))]));
}
