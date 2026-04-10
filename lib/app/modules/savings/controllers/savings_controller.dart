import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hm_tracker/constants/color.dart';
import 'package:hm_tracker/constants/url.dart';
import 'package:hm_tracker/models/saving_model.dart';
import 'package:dio/dio.dart';

final box = GetStorage();

class SavingsController extends GetxController {
  final isLoading = false.obs;
  final token = box.read('token');
  final savingList = <Saving>[].obs;
  final totalSaving = 0.obs;
  final dio = Dio();

  void onInit() {
    super.onInit();
    getSavings();
  }

  Future<void> getSavings() async {
    try {
      isLoading.value = true;
      final response = await dio.get(
        '${API_URL}savings',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        final responseData = response.data['data'];
        totalSaving.value = responseData['total'];
        final List<dynamic> dataList = responseData['savings'];
        savingList.assignAll(
          dataList
              .map((item) => Saving.fromJson(item as Map<String, dynamic>))
              .toList(),
        );
      }
    } catch (e) {
      isLoading.value = false;
    }
  }

  Future<void> addSaving({required int? amount}) async {
    try {
      isLoading.value = true;
      final response = await dio.post(
        '${API_URL}saving/store',
        data: {'amount': amount},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 201) {
        isLoading.value = false;
        Get.snackbar(
          'Berhasil',
          response.data['message'],
          colorText: appWhite,
          backgroundColor: Colors.green,
        );

        getSavings();
      }
    } catch (e) {
      isLoading.value = false;
      print(e);
    }
  }

  Future<void> editSaving({String? savingId, int? amount}) async {
    try {
      isLoading.value = true;
      final response = await dio.patch(
        '${API_URL}saving/update/$savingId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {'amount': amount},
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        Get.snackbar(
          'Berhasil!',
          'Data berhasil di update!',
          colorText: appWhite,
          backgroundColor: Colors.green,
        );
        getSavings();
      }
    } catch (e) {
      isLoading.value = false;
      print(e);
    }
  }

  Future<void> deleteSaving(String? id) async {
    try {
      isLoading.value = true;
      final response = await dio.delete(
        '${API_URL}saving/delete/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        isLoading.value = false;
        Get.snackbar(
          'Berhasil',
          'Data berhasil di hapus!',
          colorText: appWhite,
          backgroundColor: Colors.green,
        );
        getSavings();
      }
    } catch (e) {
      isLoading.value = false;
      print(e);
    }
  }
}
