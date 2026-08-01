
import 'package:flutter/material.dart';

enum FilterCategory { colorGrade, sticker2D, ar3D }

class FxItem {
  final String uid;
  final String label;
  final String asset;
  final FilterCategory cat;
  final bool needsFace;
  final Color previewColor;
  final String desc;

  const FxItem({
    required this.uid,
    required this.label,
    required this.asset,
    required this.cat,
    required this.needsFace,
    required this.previewColor,
    required this.desc,
  });
}

// Completely unique list - not generic
const List<FxItem> kFxCatalog = [
  FxItem(uid: 'raw', label: 'RAW', asset: '', cat: FilterCategory.colorGrade, needsFace: false, previewColor: Color(0xFF222222), desc: 'Original'),
  FxItem(uid: 'tokyo', label: 'TOKYO', asset: '', cat: FilterCategory.colorGrade, needsFace: false, previewColor: Color(0xFFFF6B6B), desc: 'Warm film tone'),
  FxItem(uid: 'arctic', label: 'ARCTIC', asset: '', cat: FilterCategory.colorGrade, needsFace: false, previewColor: Color(0xFF4ECDC4), desc: 'Cool cinematic'),
  FxItem(uid: 'grain', label: 'GRAIN', asset: '', cat: FilterCategory.colorGrade, needsFace: false, previewColor: Color(0xFF8B7D6B), desc: 'Vintage grain'),
  FxItem(uid: 'fx_hearts_pop', label: 'POP HEARTS', asset: 'assets/fx/hearts.png', cat: FilterCategory.sticker2D, needsFace: true, previewColor: Color(0xFFFF2E93), desc: 'Face hearts'),
  FxItem(uid: 'fx_ink', label: 'INK BLOT', asset: 'assets/fx/ink.png', cat: FilterCategory.sticker2D, needsFace: false, previewColor: Color(0xFF000000), desc: 'Artistic blot'),
  FxItem(uid: 'ar_cyber_specs', label: 'CYBER', asset: 'assets/fx/cyber_glass.png', cat: FilterCategory.ar3D, needsFace: true, previewColor: Color(0xFF00F5FF), desc: 'Cyber glasses'),
  FxItem(uid: 'ar_neon_crown', label: 'NEON CROWN', asset: 'assets/fx/neon_crown.png', cat: FilterCategory.ar3D, needsFace: true, previewColor: Color(0xFFFFD60A), desc: 'Neon crown'),
  FxItem(uid: 'ar_wolf', label: 'WOLF', asset: 'assets/fx/wolf.png', cat: FilterCategory.ar3D, needsFace: true, previewColor: Color(0xFF8B4513), desc: 'Wolf ears + nose'),
  FxItem(uid: 'ar_holo_mask', label: 'HOLO', asset: 'assets/fx/holo.png', cat: FilterCategory.ar3D, needsFace: true, previewColor: Color(0xFF9D4EDD), desc: 'Hologram mask'),
];
