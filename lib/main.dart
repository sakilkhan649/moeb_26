
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:moeb_26/Services/firebase_notification_service.dart';

import 'Core/Binding/initial_binding.dart';
import 'Core/routs.dart';
import 'Utils/app_colors.dart';

void main() async {

    // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
      await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize Firebase Messaging
  await FirebaseNotificationService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(376, 856),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.black100,
        ),
        debugShowCheckedModeBanner: false,
        getPages: Routes.routes,
        initialRoute: Routes.splashScreen,
        initialBinding: InitialBinding(),
      ),
    );
  }
}
 ///This main branch ui update

