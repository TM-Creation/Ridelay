import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:ridely/src/app.dart';
import 'package:ridely/src/models/globals.dart' as globals;
import 'package:ridely/src/presentation/ui/config/debug_helper.dart';
import 'package:device_preview/device_preview.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  globals.cameras = await availableCameras();
  runApp(DevicePreview(
    enabled: true,
    builder: (context) => App(), // Wrap your app
  ),);
}
/*Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  globals.cameras = await availableCameras();
  runApp(const App());
}*/
