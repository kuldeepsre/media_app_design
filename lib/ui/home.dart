
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'live_cam.dart';
import 'gallery_pick.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('UNIQUE', style: TextStyle(color: AppColors.accent, fontSize: 12, letterSpacing: 4, fontWeight: FontWeight.bold)),
            Text('AR STUDIO', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900, height: 0.9)),
            Text('CUSTOM ENGINE • NO TEMPLATE', style: TextStyle(color: Colors.white38, fontSize: 10)),
            Spacer(),
            _card(context, title: 'LIVE AR', sub: 'Face mesh + Custom Pixel Compositor', icon: Icons.face_retouching_natural, color: AppColors.accent, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LiveCam()))),
            SizedBox(height: 14),
            _card(context, title: 'IMPORT & RENDER', sub: 'Decode → Render → Encode workflow', icon: Icons.layers, color: AppColors.accent2, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GalleryPick()))),
            SizedBox(height: 20),
            Container(padding: EdgeInsets.all(14), decoration: BoxDecoration(border: Border.all(color: Colors.white10), borderRadius: BorderRadius.circular(12)), child: Row(children: [Icon(Icons.verified, color: AppColors.accent, size: 16), SizedBox(width: 8), Expanded(child: Text('100% Unique Code - Custom PixelCompositor, no FFmpeg, new file creation proof', style: TextStyle(color: Colors.white54, fontSize: 11)))])),
          ]),
        ),
      ),
    );
  }

  Widget _card(BuildContext context, {required String title, required String sub, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)),
        child: Row(children: [
          Container(padding: EdgeInsets.all(14), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: Colors.black)),
          SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)), Text(sub, style: TextStyle(color: Colors.white38, fontSize: 11))])),
          Icon(Icons.arrow_forward, color: Colors.white),
        ]),
      ),
    );
  }
}
