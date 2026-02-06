// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../Services/auth_service.dart';
// import '../routs.dart';
//
// class AuthMiddleware extends GetMiddleware {
//   final AuthService _authService = Get.put(AuthService());
//
//   @override
//   RouteSettings? redirect(String? route) {
//     // Check if user is logged in
//     if (!_authService.isLoggedIn.value) {
//       return const RouteSettings(name: Routes.signscreen);
//     }
//     return null;
//   }
// }
