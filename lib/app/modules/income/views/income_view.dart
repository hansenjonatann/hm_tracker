import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hm_tracker/app/widget/bottom_navbar.dart';
import 'package:hm_tracker/constants/color.dart';
import 'package:hm_tracker/utils/format-rupiah.dart';
import 'package:intl/intl.dart';
import '../controllers/income_controller.dart';

class IncomeView extends GetView<IncomeController> {
  IncomeView({super.key});

  final incomeC = Get.find<IncomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      extendBody: true,
      body: Obx(() {
        if (incomeC.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: appWhite),
                SizedBox(height: 16),
                Text("Memuat data...", style: TextStyle(color: appWhite)),
              ],
            ),
          );
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Pemasukan",
                  style: TextStyle(
                    fontSize: 24.0,
                    color: appWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),

                // Card Total
                _buildTotalIncomeCard(),

                const SizedBox(height: 20),
                const Text(
                  "Daftar Pemasukan",
                  style: TextStyle(
                    color: appWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),

                Expanded(
                  child: Obx(() {
                    // Pastikan Obx membungkus list dengan benar
                    if (incomeC.incomes.isEmpty) {
                      return const Center(
                        child: Text(
                          "Belum ada data",
                          style: TextStyle(color: Colors.white54),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: incomeC
                          .incomes
                          .length, // Gunakan langsung tanpa .value
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final income = incomeC.incomes[index];

                        return _buildTransactionItem(
                          id: income.id ?? '',
                          title: income.desc ?? "-",
                          // Gunakan safe navigation ? dan default value ??
                          category: income.category?.name ?? '-',
                          date: income.date,
                          amount: income.amount ?? 0,
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => _showAddBottomSheet(),
        child: const Icon(Icons.add, color: Colors.black),
      ),
      bottomNavigationBar: const CustomBottomNavbar(currentIndex: 1),
    );
  }

  // Widget Total Pemasukan
  Widget _buildTotalIncomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text(
          "Total Pemasukan",
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        subtitle: Text(
          formatRupiah(incomeC.totalIncome.value),
          style: const TextStyle(
            fontSize: 28.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem({
    required String id,
    required DateTime? date,
    required String title,
    required String category,
    required int amount,
  }) {
    String day = date != null ? DateFormat('dd').format(date) : '--';
    String month = date != null ? DateFormat('MMM').format(date) : '...';

    return Dismissible(
      key: Key(id),
      direction: DismissDirection.endToStart, // Geser dari kanan ke kiri
      confirmDismiss: (direction) async {
        // Menampilkan dialog konfirmasi sebelum benar-benar menghapus
        return await Get.defaultDialog(
          title: "Hapus Data",
          middleText: "Apakah kamu yakin ingin menghapus pemasukan ini?",
          backgroundColor: primary,
          titleStyle: const TextStyle(color: Colors.white),
          middleTextStyle: const TextStyle(color: Colors.white70),
          textConfirm: "Ya, Hapus",
          textCancel: "Batal",
          confirmTextColor: Colors.black,
          buttonColor: Colors.redAccent,
          onConfirm: () {
            // incomeC.deleteIncome(id); // Panggil fungsi delete di controller
            controller.deleteIncome(id);
            Get.back(result: true); // Menutup dialog dan mengizinkan dismiss
          },
          onCancel: () => Get.back(result: false),
        );
      },
      // Background saat digeser
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Row(
          children: [
            // LINGKARAN TANGGAL
            Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                color: Colors.greenAccent.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day,
                    style: GoogleFonts.inter(
                      color: Colors.greenAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    month.toUpperCase(),
                    style: GoogleFonts.inter(
                      color: Colors.greenAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // KONTEN
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category,
                    style: GoogleFonts.inter(
                      color: Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // JUMLAH
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.greenAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "+${formatRupiah(amount)}",
                style: GoogleFonts.inter(
                  color: Colors.greenAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddBottomSheet() {
    // Reset field sebelum tampil
    incomeC.descC.clear();
    incomeC.amountC.clear();
    incomeC.selectedCategoryId.value = "";
    incomeC.selectedDate.value = DateTime.now();

    Get.bottomSheet(
      Container(
        // Atur tinggi maksimal agar tidak menutupi seluruh layar jika tidak perlu
        constraints: BoxConstraints(maxHeight: Get.height * 0.85),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: primary, // Pakai warna background gelap kamu
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle Bar (Garis kecil di atas)
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              Text(
                "Tambah Pemasukan",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // FIELD TANGGAL
              const Text(
                "Tanggal",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Obx(
                () => InkWell(
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: Get.context!,
                      initialDate: incomeC.selectedDate.value,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) incomeC.selectedDate.value = picked;
                  },
                  child: _buildInputContainer(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat(
                            'dd/MM/yyyy',
                          ).format(incomeC.selectedDate.value),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const Icon(
                          Icons.calendar_month,
                          color: Colors.greenAccent,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // FIELD KETERANGAN
              const Text(
                "Keterangan",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: incomeC.descC,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Contoh: Gaji Bulanan"),
              ),

              const SizedBox(height: 16),

              // FIELD KATEGORI
              const Text(
                "Kategori",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Obx(
                () => _buildInputContainer(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      itemHeight: null,
                      isDense: false,

                      dropdownColor: primary,
                      value: incomeC.selectedCategoryId.value.isEmpty
                          ? null
                          : incomeC.selectedCategoryId.value,
                      hint: const Text(
                        "Pilih Kategori",
                        style: TextStyle(color: Colors.white24),
                      ),
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                      items: incomeC.categories.map((cat) {
                        return DropdownMenuItem(
                          value: cat.id,
                          child: Text(
                            cat.name ?? "",
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          incomeC.selectedCategoryId.value = val!,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // FIELD JUMLAH
              const Text(
                "Jumlah (Rp)",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: incomeC.amountC,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                decoration: _inputDecoration("5000000"),
              ),

              const SizedBox(height: 30),

              // TOMBOL SIMPAN
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => incomeC.storeIncome(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    "Simpan Pemasukan",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // TOMBOL BATAL
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    "Batal",
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Padding bawah ekstra
            ],
          ),
        ),
      ),
      isScrollControlled:
          true, // Agar bottom sheet bisa naik saat keyboard muncul
      ignoreSafeArea: false,
    );
  }

  // Helper untuk styling biar kode rapi
  Widget _buildInputContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: child,
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      contentPadding: const EdgeInsets.all(12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.greenAccent),
      ),
    );
  }
}
