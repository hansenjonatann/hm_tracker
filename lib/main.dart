import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hm_tracker/app/controllers/auth_controller.dart';
import 'app/routes/app_pages.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
  }
}

void main() async {
  // 1. Initialize GetStorage before using it

  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  final box = GetStorage();

  // 2. Check if the token exists and is not empty
  // We use ?? to handle the null case safely
  final String? token = box.read('token');
  final bool isLoggedIn = token != null && token.isNotEmpty;

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "HM Tracker",
      initialBinding: InitialBinding(),
      // 3. Use the boolean check here
      initialRoute: isLoggedIn ? Routes.HOME : AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
