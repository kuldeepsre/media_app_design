
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'logic/fx_brain.dart';
import 'logic/cam_brain.dart';
import 'logic/render_brain.dart';
import 'ui/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const UniqueApp());
}

class UniqueApp extends StatelessWidget {
  const UniqueApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FxBrain()),
        ChangeNotifierProvider(create: (_) => CamBrain()),
        ChangeNotifierProvider(create: (_) => RenderBrain()),
      ],
      child: MaterialApp(debugShowCheckedModeBanner: false, title: 'Unique AR Studio', theme: ThemeData.dark(useMaterial3: true), home: Home()),
    );
  }
}
