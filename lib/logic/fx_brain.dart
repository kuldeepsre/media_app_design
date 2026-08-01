
import 'package:flutter/foundation.dart';
import '../data/filter_catalog.dart';

class FxBrain extends ChangeNotifier {
  List<FxItem> _catalog = kFxCatalog;
  int _activeIdx = 0;
  double _power = 1.0;

  List<FxItem> get catalog => _catalog;
  FxItem get activeFx => _catalog[_activeIdx];
  int get activeIdx => _activeIdx;
  double get power => _power;

  void pick(int idx) {
    _activeIdx = idx;
    notifyListeners();
  }

  void setPower(double v) {
    _power = v.clamp(0.0, 1.0);
    notifyListeners();
  }

  List<FxItem> get colorFx => _catalog.where((e) => e.cat == FilterCategory.colorGrade).toList();
  List<FxItem> get arFx => _catalog.where((e) => e.cat == FilterCategory.ar3D).toList();
}
