import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hm_tracker/constants/color.dart';
import 'package:hm_tracker/utils/format-rupiah.dart';

import '../controllers/savings_controller.dart';

class SavingsView extends GetView<SavingsController> {
  SavingsView({super.key});
  final controller = Get.put(SavingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary, // Background gelap Anda
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER & TOTAL SALDO ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    "Total Tabungan",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: appWhite.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => Text(
                      formatRupiah(controller.totalSaving.value),
                      style: GoogleFonts.inter(
                        fontSize: 32,
                        color: appWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white12, thickness: 1),
                ],
              ),
            ),

            // --- LIST DATA ---
            Expanded(
              child: Obx(
                () => Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                    itemCount: controller
                        .savingList
                        .length, // Sesuaikan dengan controller.list.length
                    itemBuilder: (context, index) {
                      final saving = controller.savingList[index];
                      return _buildTransactionItem(
                        context,
                        index,
                        saving.amount,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormModal(context),
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget _buildTransactionItem(
    BuildContext context,
    int index,

    dynamic saving,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          // Lingkaran Nomor
          Container(
            height: 35,
            width: 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "#${index + 1}", // Menggunakan index asli
              style: GoogleFonts.inter(
                color: appWhite,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 15),
          // Nominal
          Expanded(
            child: Text(
              formatRupiah(saving),
              style: GoogleFonts.inter(
                color: appWhite,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),
          // Action Buttons
          Row(
            children: [
              // TOMBOL EDIT
              _iconButton(Icons.edit_outlined, Colors.blue, () {
                _showFormModal(context, index: index);
              }),
              const SizedBox(width: 8),
              // TOMBOL DELETE
              _iconButton(Icons.delete_outline, Colors.redAccent, () {
                // Tambahkan Konfirmasi sebelum hapus
                Get.defaultDialog(
                  title: "Hapus Data",
                  middleText: "Yakin ingin menghapus tabungan ini?",
                  backgroundColor: primary,
                  titleStyle: const TextStyle(color: Colors.white),
                  middleTextStyle: const TextStyle(color: Colors.white70),
                  textConfirm: "Ya, Hapus",
                  textCancel: "Batal",
                  confirmTextColor: Colors.white,
                  buttonColor: Colors.redAccent,
                  onConfirm: () {
                    final saving = controller.savingList[index];
                    controller.deleteSaving(saving.id);
                    Get.back(); // Tutup dialog
                  },
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}

void _showFormModal(BuildContext context, {int? index}) {
  final TextEditingController _amountC = new TextEditingController();

  final _savingC = Get.find<SavingsController>();
  // Jika edit, isi field dengan nominal yang lama
  if (index != null) {
    _amountC.text = _savingC.savingList[index].amount.toString();
  }

  print(index);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Agar modal naik saat keyboard muncul
    backgroundColor: Colors.transparent,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(
          context,
        ).viewInsets.bottom, // Penyesuaian keyboard
      ),
      child: Container(
        decoration: BoxDecoration(
          color: primary, // Mengikuti background aplikasi
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: appWhite,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              index == null ? "Tambah Tabungan" : "Edit Tabungan",
              style: GoogleFonts.inter(
                color: appWhite,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _amountC,
              autofocus: true,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                labelText: "Jumlah (Amount)",
                labelStyle: const TextStyle(color: Colors.white60),
                prefixText: "Rp ",
                prefixStyle: const TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.white12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.blueAccent),
                ),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: appWhite),
                onPressed: () {
                  if (_amountC.text.isNotEmpty) {
                    if (index == null) {
                      _savingC.addSaving(amount: int.parse(_amountC.text));
                    } else {
                      final saving = _savingC.savingList[index];

                      _savingC.editSaving(
                        savingId: saving.id,
                        amount: int.parse(_amountC.text),
                      );
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  "Simpan Perubahan",
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
