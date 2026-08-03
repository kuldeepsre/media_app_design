
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/cam_brain.dart';
import '../logic/fx_brain.dart';
import 'components/fx_strip.dart';
import 'edit_photo.dart';
import 'edit_video.dart';
import '../core/app_colors.dart';

class LiveCam extends StatefulWidget {
  const LiveCam({super.key});
  @override
  State<LiveCam> createState() => _LiveCamState();
}

class _LiveCamState extends State<LiveCam> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<CamBrain>().boot());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer2<CamBrain, FxBrain>(
        builder: (_, cam, fx, __) {
          if (!cam.ready) return Center(child: CircularProgressIndicator(color: AppColors.accent));
          return Stack(children: [
            CameraPreview(cam.ctrl!),
            // Live preview tint
            if (fx.activeFx.uid == 'tokyo') Container(color: Color(0xFFFF6B6B).withOpacity(0.18 * fx.power)),
            if (fx.activeFx.uid == 'arctic') Container(color: Color(0xFF4ECDC4).withOpacity(0.15 * fx.power)),
            if (fx.activeFx.needsFace && cam.faceNow != null)
              Positioned(top: 120, left: 0, right: 0, child: Center(child: Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(12)), child: Text('FACE LOCKED • ${fx.activeFx.label}', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold))))),
            Positioned(top: 50, left: 16, right: 16, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _btn(Icons.flash_on, cam.toggleFlash, active: cam.flashOn),
              Text('LIVE • ${fx.activeFx.label}', style: TextStyle(color: Colors.white, fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.bold)),
              _btn(Icons.switch_camera, cam.flip),
            ])),
            Positioned(bottom: 140, left: 0, right: 0, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              GestureDetector(
                onTap: () async {
                  final file = await cam.snap();
                  if (!mounted) return;
                  Navigator.push(context, MaterialPageRoute(builder: (_) => EditPhoto(path: file.path)));
                },
                onLongPress: () async {
                  await cam.ctrl!.startVideoRecording();
                  setState(() => cam.recording = true);
                },
                onLongPressUp: () async {
                  final f = await cam.ctrl!.stopVideoRecording();
                  setState(() => cam.recording = false);
                  if (!mounted) return;
                  Navigator.push(context, MaterialPageRoute(builder: (_) => EditVideo(path: f.path)));
                },
                child: Container(width: 76, height: 76, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: cam.recording ? Colors.red : Colors.white, width: 4)), child: Center(child: Container(width: cam.recording ? 32 : 60, height: cam.recording ? 32 : 60, decoration: BoxDecoration(color: cam.recording ? Colors.red : Colors.white, borderRadius: BorderRadius.circular(cam.recording ? 6 : 30))))),
              ),
            ])),
            Positioned(bottom: 0, left: 0, right: 0, child: FxStrip()),
          ]);
        },
      ),
    );
  }

  Widget _btn(IconData ic, VoidCallback tap, {bool active = false}) => GestureDetector(onTap: tap, child: Container(width: 38, height: 38, decoration: BoxDecoration(color: active ? AppColors.accent : Colors.black54, shape: BoxShape.circle), child: Icon(ic, color: active ? Colors.black : Colors.white, size: 18)));
}
