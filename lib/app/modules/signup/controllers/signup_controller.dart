import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:hm_tracker/constants/color.dart';
import 'package:hm_tracker/constants/url.dart';

class SignupController extends GetxController {
  final isLoading = false.obs;
  final dio = Dio();
  void register({
    required String name,
    required String email,
    required String password,
    required String confirmationPassword,
    required String username,
  }) async {
    try {
      isLoading.value = true;

      if (confirmationPassword.length < 8 && password.length < 8) {
        isLoading.value = false;
        Get.snackbar(
          'Gagal!',
          'Masukkan kata sandi Anda minimal 8 karakter!',
          colorText: appWhite,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
        return;
      }

      if (confirmationPassword != password) {
        isLoading.value = false;
        Get.snackbar(
          "Gagal!",
          "Kata sandi dan Konfirmasi Kata Sandi anda tidak sama!",
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
        return;
      }

      if (username.isEmpty ||
          password.isEmpty ||
          name.isEmpty ||
          email.isEmpty ||
          confirmationPassword.isEmpty) {
        isLoading.value = false;
        Get.snackbar(
          "Gagal!",
          "Field wajib diisi!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final response = await dio.post(
        '${API_URL}auth/sign-up',
        data: {
          'name': name,
          'username': username,
          'password': password,
          'email': email,
        },
      );

      if (response.statusCode == 201) {
        isLoading.value = false;
        Get.snackbar(
          "Berhasil!",
          "Pendaftaran berhasil!",
          colorText: Colors.white,
          backgroundColor: Colors.lightGreen,
        );
        Get.offNamed('/signin');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Gagal!",
        e.toString(),
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }
}
