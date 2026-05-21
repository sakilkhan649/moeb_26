import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:moeb_26/app.dart';
import 'package:moeb_26/core/services/firebase_notification_service.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Firebase Messaging
  await FirebaseNotificationService.initialize();
  runApp(const MyApp());
}

///This main branch ui update
///
