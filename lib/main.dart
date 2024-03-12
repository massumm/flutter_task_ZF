import 'package:flutter/material.dart';
import 'package:flutter_fz_task/ui/Home.dart';
import 'package:flutter_fz_task/ui/Login.dart';
import 'package:get/get.dart';


import 'api_service/AuthController.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiController authController = Get.put(ApiController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Your App',
      initialRoute: '/login',
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/home', page: () => HomeScreen()),
      ],
    );
  }
}
