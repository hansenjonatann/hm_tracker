import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hm_tracker/constants/color.dart';
import 'package:hm_tracker/constants/url.dart';
import 'package:hm_tracker/models/user_model.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;
  final userProfile = Rx<User>(User());
  final dio = Dio();
  final box = GetStorage();

  @override
  void onInit() async {
    super.onInit();
    String? token = await box.read('token');
    if (token != null) {
      profile();
    }
  }

  void login({required String username, required String password}) async {
    try {
      isLoading.value = true;
      final response = await dio.post(
        '${API_URL}auth/sign-in',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        await box.write('token', response.data['data']['token']);
        await profile();
        Get.snackbar(
          "Berhasil",
          response.data['message'],
          backgroundColor: Colors.lightGreen,
          colorText: appWhite,
        );
        Get.offNamed("/home");
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Gagal!",
        "Terjadi kesalahan saat masuk!",

        colorText: appWhite,
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> profile() async {
    try {
      isLoading.value = true;
      final token = await box.read('token');

      final response = await dio.get(
        '${API_URL}auth/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        isLoading.value = false;
        userProfile.value = User.fromJson(response.data['user']);
      }
    } catch (e) {
      Get.snackbar(
        "Gagal!",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: appWhite,
      );
    }
  }

  void signOut() async {
    try {
      isLoading.value = true;
      final token = await box.read('token');

      final response = await dio.post(
        '${API_URL}auth/sign-out',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        isLoading.value = false;
        Get.snackbar(
          'Logout Berhasil!',
          response.data['message'],
          colorText: appWhite,
          backgroundColor: Colors.green,
        );
        _clearSession();
      }
    } catch (e) {
      isLoading.value = false;
      print(e);
    }
  }

  void _clearSession() {
    box.remove('token'); // Hapus token dari memori HP
    userProfile.value = User(); // Reset data profile
    Get.offAllNamed('/signin'); // Pindah ke signin & hapus semua history page
  }
}
