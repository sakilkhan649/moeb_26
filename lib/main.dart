import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moeb_26/app.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

///This main branch ui update
///
