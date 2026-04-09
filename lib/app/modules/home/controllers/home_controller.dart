import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hm_tracker/constants/url.dart';

class HomeController extends GetxController {
  final isObscured = false.obs;
  final dio = Dio();
  final box = GetStorage();
  final isLoading = false.obs;

  // Variabel untuk menampung data
  final totalIncomeAmount = 0.obs; // Untuk menampung "total_income" dari API
  final totalExpenseAmount = 0.obs; // Untuk menampung "total_income" dari API
  final totalSavingsAmount = 0.obs; // Untuk menampung "total_income" dari API
  final totalAmount = 0.obs;

  final incomeSpots = <FlSpot>[].obs;
  final expenseSpots = <FlSpot>[].obs;
  @override
  void onInit() {
    super.onInit();

    fetchAllData();
  }

  Future<void> fetchAllData() async {
    try {
      isLoading.value = true;

      // Mengambil semua data secara paralel dan menunggu semuanya selesai
      final results = await Future.wait([
        getIncomesData(),
        getExpensesData(),
        getSavingsData(),
      ]);

      // 2. Ambil data list mentah dari hasil results
      final List rawIncomes = results[0] as List? ?? [];
      final List rawExpenses = results[1] as List? ?? [];

      // Setelah semua data API masuk ke variabel .value, baru update dashboard
      generateCharts(rawIncomes, rawExpenses);
      calculatedTotal();
    } catch (e) {
      print("Error fetching all data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void generateCharts(List incomes, List expenses) {
    // 1. Kelompokkan nominal berdasarkan tanggal (Map agar tanggal yang sama terjumlahkan)
    Map<int, double> incomeMap = {};
    Map<int, double> expenseMap = {};

    // Proses Incomes
    for (var item in incomes) {
      DateTime date = DateTime.parse(item['date']);
      int day = date
          .day; // Menggunakan hari sebagai sumbu X (misal: tanggal 1, 2, 28)
      double amount = (item['amount'] as num).toDouble();

      incomeMap[day] = (incomeMap[day] ?? 0) + amount;
    }

    // Proses Expenses
    for (var item in expenses) {
      DateTime date = DateTime.parse(item['date']);
      int day = date.day;
      double amount = (item['amount'] as num).toDouble();

      expenseMap[day] = (expenseMap[day] ?? 0) + amount;
    }

    // 2. Ubah Map menjadi List<FlSpot> dan urutkan berdasarkan hari
    var sortedIncomeDays = incomeMap.keys.toList()..sort();
    incomeSpots.value = sortedIncomeDays
        .map((day) => FlSpot(day.toDouble(), incomeMap[day]!))
        .toList();

    var sortedExpenseDays = expenseMap.keys.toList()..sort();
    expenseSpots.value = sortedExpenseDays
        .map((day) => FlSpot(day.toDouble(), expenseMap[day]!))
        .toList();
  }

  void calculatedTotal() {
    // Hitung saldo akhir: Pemasukan - (Pengeluaran + Tabungan)
    // Atau sesuaikan logika bisnis Anda
    totalAmount.value =
        totalIncomeAmount.value +
        (totalExpenseAmount.value + totalSavingsAmount.value);
  }

  void toggleVisibility() {
    isObscured.value = !isObscured.value;
  }

  Future<void> getIncomesData() async {
    try {
      isLoading.value = true;
      final token = box.read('token');

      final response = await dio.get(
        '${API_URL}incomes/list',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // --- PARSING SESUAI STRUKTUR JSON BARU ---
        // response.data -> { "data": { "incomes": [...], "total_income": 562000 }, "message": "..." }
        isLoading.value = false;

        var responseData = response.data['data']; // Masuk ke object "data"

        // Simpan total_income ke variabel observable
        totalIncomeAmount.value = responseData['total_income'] ?? 0;
        return responseData['incomes'] ?? [];

        // Map ke Model Income
      }
    } catch (e) {
      isLoading.value = false;
      print("Error Detail: $e");
    } finally {
      isLoading.value = false;
      print('Kode berhasil dieksekusi!');
    }
  }

  Future<void> getExpensesData() async {
    try {
      isLoading.value = true;
      final token = box.read('token');

      final response = await dio.get(
        '${API_URL}expenses',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        final responseData = response.data['data'];
        totalExpenseAmount.value = responseData['total'];
        return responseData['expense'] ?? [];
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getSavingsData() async {
    try {
      isLoading.value = true;
      final token = box.read('token');

      final response = await dio.get(
        '${API_URL}savings',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        final responseData = response.data['data'];
        totalSavingsAmount.value = responseData['total'];
      }
    } catch (e) {
      isLoading.value = false;
      print(e);
    }
  }
}
