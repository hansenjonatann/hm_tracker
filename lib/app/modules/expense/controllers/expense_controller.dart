import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hm_tracker/constants/color.dart';
import 'package:hm_tracker/constants/url.dart';
import 'package:hm_tracker/models/category_expense_model.dart';
import 'package:hm_tracker/models/category_income_model.dart';
import 'package:hm_tracker/models/expense_model.dart';
import 'package:hm_tracker/models/income_model.dart';
import 'package:intl/intl.dart';

class ExpenseController extends GetxController {
  final isLoading = false.obs;
  final box = GetStorage();
  final dio = Dio();

  // Perubahan: Gunakan RxList agar lebih reaktif dan mudah dikelola
  final expenses = <Expense>[].obs;
  final totalExpense = 0.obs;

  final titleC = TextEditingController();
  final amountC = TextEditingController();
  final descC = TextEditingController(); // Untuk Keterangan
  var selectedDate = DateTime.now().obs;
  var selectedCategoryId = "".obs; //

  final categories = <CategoryExpense>[].obs;

  @override // Jangan lupa tambahkan decorator override
  void onInit() {
    super.onInit();
    getExpensesData();
    getCategoriesIncomeData();
  }

  void getCategoriesIncomeData() async {
    try {
      isLoading.value = true;
      final response = await dio.get('${API_URL}category/expense');
      if (response.statusCode == 200) {
        isLoading.value = false;
        final List<dynamic> data = response.data['data'];
        print(data);
        // Mapping ke Model CategoryIncome
        categories.assignAll(
          data.map((item) => CategoryExpense.fromJson(item)).toList(),
        );
      }
    } catch (e) {
      isLoading.value = false;
    }
  }

  void getExpensesData() async {
    try {
      isLoading.value = true;
      final token = box.read('token');

      final response = await dio.get(
        '${API_URL}expenses',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        // Ambil data dari struktur response API kamu
        final responseData = response.data['data'];
        final List<dynamic> dataList = responseData['expense'];

        // Update total
        totalExpense.value = responseData['total'] ?? 0;

        // Update List: Gunakan assignAll untuk mengganti seluruh isi list
        expenses.assignAll(
          dataList
              .map((item) => Expense.fromJson(item as Map<String, dynamic>))
              .toList(),
        );
      }
    } catch (e) {
      print("Error fetching expenses: $e");
    } finally {
      // Gunakan finally agar loading berhenti baik sukses maupun error
      isLoading.value = false;
    }
  }

  // Di dalam IncomeController
  Future<void> storeExpense() async {
    // Validasi sederhana
    if (amountC.text.isEmpty || selectedCategoryId.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Jumlah dan Kategori wajib diisi",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      final token = box.read('token');

      final response = await dio.post(
        '${API_URL}expenses/store',
        data: {
          'desc': descC.text, // Mengambil dari field Keterangan
          'amount': int.tryParse(amountC.text) ?? 0, // Konversi String ke Int
          'date': DateFormat(
            'yyyy-MM-dd',
          ).format(selectedDate.value), // Dari DatePicker
          'category_expense': selectedCategoryId.value, // Dari Dropdown
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back(); // Tutup dialog

        // Reset Form
        descC.clear();
        amountC.clear();
        selectedCategoryId.value = "";

        Get.snackbar(
          "Sukses",
          "Data berhasil disimpan",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Refresh list utama
        getExpensesData();
      }
    } catch (e) {
      print("Error store expense: $e");
      Get.snackbar(
        "Error",
        "Gagal menyimpan data",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      isLoading.value = true;
      final token = box.read('token');
      final response = await dio.delete(
        '${API_URL}expenses/delete/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        isLoading.value = false;
        Get.snackbar(
          "Berhasil!",
          response.data['message'],
          backgroundColor: Colors.green,
          colorText: appWhite,
        );
        getExpensesData();
      }
    } catch (e) {
      isLoading.value = false;
      print(e);
    }
  }
}
