
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/fx_brain.dart';
import '../../core/app_colors.dart';

class FxStrip extends StatelessWidget {
  const FxStrip({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<FxBrain>(
      builder: (_, brain, __) {
        return Container(
          padding: EdgeInsets.only(top: 12, bottom: 20),
          decoration: BoxDecoration(color: AppColors.card.withOpacity(0.9), borderRadius: BorderRadius.vertical(top: Radius.circular(28)), border: Border(top: BorderSide(color: Colors.white10))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 36, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
              SizedBox(height: 14),
              if (brain.activeFx.uid != 'raw')
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(children: [
                    Text('POWER', style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1.5)),
                    Expanded(child: Slider(value: brain.power, onChanged: brain.setPower, activeColor: AppColors.accent, inactiveColor: Colors.white12)),
                    Text('${(brain.power*100).toInt()}%', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ]),
                ),
              SizedBox(height: 8),
              SizedBox(
                height: 78,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: brain.catalog.length,
                  separatorBuilder: (_, __) => SizedBox(width: 12),
                  itemBuilder: (_, i) {
                    final fx = brain.catalog[i];
                    final sel = i == brain.activeIdx;
                    return GestureDetector(
                      onTap: () => brain.pick(i),
                      child: Column(children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 220),
                          width: 56, height: 56,
                          decoration: BoxDecoration(color: sel ? AppColors.accent : fx.previewColor, shape: BoxShape.circle, border: Border.all(color: sel ? Colors.white : Colors.transparent, width: 2), boxShadow: sel ? [BoxShadow(color: fx.previewColor.withOpacity(0.5), blurRadius: 12)] : []),
                          child: Center(child: Text(fx.label[0], style: TextStyle(color: sel ? Colors.black : Colors.white, fontWeight: FontWeight.w900, fontSize: 14))),
                        ),
                        SizedBox(height: 6),
                        Text(fx.label, style: TextStyle(color: sel ? Colors.white : Colors.white38, fontSize: 9, fontWeight: sel ? FontWeight.bold : FontWeight.normal)),
                      ]),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
