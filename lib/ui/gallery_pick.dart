
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/app_colors.dart';
import 'edit_photo.dart';
import 'edit_video.dart';

class GalleryPick extends StatelessWidget {
  const GalleryPick({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(backgroundColor: AppColors.bg, title: Text('IMPORT', style: TextStyle(color: Colors.white, letterSpacing: 2, fontSize: 14))),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          _btn(context, 'PHOTO', 'Decode → Face Scan → Render → Encode', Icons.image, () async { final f = await ImagePicker().pickImage(source: ImageSource.gallery); if (f != null && context.mounted) Navigator.push(context, MaterialPageRoute(builder: (_) => EditPhoto(path: f.path))); }),
          SizedBox(height: 12),
          _btn(context, 'VIDEO', 'Frame Extract → Render Each → Mux New MP4', Icons.movie, () async { final f = await ImagePicker().pickVideo(source: ImageSource.gallery); if (f != null && context.mounted) Navigator.push(context, MaterialPageRoute(builder: (_) => EditVideo(path: f.path))); }),
        ]),
      ),
    );
  }

  Widget _btn(BuildContext ctx, String t, String d, IconData ic, VoidCallback tap) => GestureDetector(onTap: tap, child: Container(padding: EdgeInsets.all(18), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16)), child: Row(children: [Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)), child: Icon(ic, color: Colors.white)), SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text(d, style: TextStyle(color: Colors.white38, fontSize: 10))]))])));
}
