
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../logic/fx_brain.dart';
import '../logic/render_brain.dart';
import '../core/app_colors.dart';
import 'components/fx_strip.dart';
import 'preview_final.dart';

class EditVideo extends StatefulWidget {
  final String path;
  const EditVideo({super.key, required this.path});
  @override
  State<EditVideo> createState() => _EditVideoState();
}

class _EditVideoState extends State<EditVideo> {
  late VideoPlayerController _c;
  bool ok = false;

  @override
  void initState() {
    super.initState();
    _c = VideoPlayerController.file(File(widget.path))..initialize().then((_) { setState(() => ok = true); _c.setLooping(true); _c.play(); });
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Consumer2<FxBrain, RenderBrain>(
      builder: (_, fx, render, __) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.black, title: Text('EDIT VIDEO', style: TextStyle(color: Colors.white, fontSize: 13, letterSpacing: 2)), actions: [
            if (!render.busy) TextButton(onPressed: () async { final out = await render.renderVideo(input: File(widget.path), fx: fx.activeFx, power: fx.power); if (!mounted) return; Navigator.push(context, MaterialPageRoute(builder: (_) => PreviewFinal(file: out, isVideo: true, originalPath: widget.path))); }, child: Text('EXPORT', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold))),
          ]),
          body: Stack(children: [
            Center(child: ok ? AspectRatio(aspectRatio: _c.value.aspectRatio, child: VideoPlayer(_c)) : CircularProgressIndicator()),
            if (render.busy) Container(color: Colors.black87, child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [CircularProgressIndicator(color: AppColors.accent), SizedBox(height: 12), Text(render.log, style: TextStyle(color: Colors.white)), Text('No FFmpeg - Native Pipeline', style: TextStyle(color: Colors.white38, fontSize: 10))]))),
            Positioned(bottom: 0, left: 0, right: 0, child: FxStrip()),
          ]),
        );
      },
    );
  }
}
