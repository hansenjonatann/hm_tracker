import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hm_tracker/app/controllers/auth_controller.dart';
import 'package:hm_tracker/app/widget/bottom_navbar.dart';
import 'package:hm_tracker/constants/color.dart';
import 'package:hm_tracker/utils/format-rupiah.dart';

import '../controllers/home_controller.dart';

import 'package:fl_chart/fl_chart.dart'; // Jangan lupa install fl_chart

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final controller = Get.find<HomeController>();

  final _authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: primary,
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          // Jika isLoading true, tampilkan spinner di tengah layar
          if (controller.isLoading.value) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: appWhite),
                  SizedBox(height: 16),
                  Text(
                    "Memuat data...",
                    style: TextStyle(color: appWhite, fontSize: 14),
                  ),
                ],
              ),
            );
          }

          // Jika isLoading false, tampilkan konten utama
          return RefreshIndicator(
            onRefresh: () => controller.fetchAllData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildBalanceCard(),
                  const SizedBox(height: 12.0),
                  _buildDetailRow(),
                  const SizedBox(height: 32),
                  _buildChartSection(
                    title: "Tren Pemasukan",
                    spots: controller.incomeSpots,
                    color: Colors.greenAccent,
                  ),
                  const SizedBox(height: 24),
                  _buildChartSection(
                    title: "Tren Pengeluaran",
                    spots: controller.expenseSpots,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          );
        }),
      ),
      bottomNavigationBar: CustomBottomNavbar(currentIndex: 0),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, color: appWhite),
              ),
              const SizedBox(width: 12),
              Obx(
                () => Text(
                  '${_authC.userProfile.value.name}',
                  style: GoogleFonts.inter(
                    color: appWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              _authC.signOut();
            },
            icon: const Icon(Icons.logout, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: appWhite,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Saldo',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Obx(
                        () => Text(
                          controller.isObscured.value
                              ? 'Rp •••••••••'
                              : formatRupiah(controller.totalAmount.value),
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: controller.isObscured.value ? 2 : 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.toggleVisibility(),
                    child: Icon(
                      controller.isObscured.value
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: Colors.grey[400],
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(
        () => Row(
          children: [
            _buildDetailCard(
              label: "Pemasukan",
              amount: formatRupiah(controller.totalIncomeAmount.value),
              icon: Icons.arrow_downward_rounded,
              color: Colors.green[600]!,
            ),
            const SizedBox(width: 10),
            _buildDetailCard(
              label: "Pengeluaran",
              amount: formatRupiah(controller.totalExpenseAmount.value),
              icon: Icons.arrow_upward_rounded,
              color: Colors.red[600]!,
            ),
            const SizedBox(width: 10),
            _buildDetailCard(
              label: "Tabungan",
              amount: formatRupiah(controller.totalSavingsAmount.value),
              icon: Icons.account_balance_wallet_rounded,
              color: Colors.blue[600]!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection({
    required String title,
    required List<FlSpot> spots,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              color: appWhite,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 180,
            padding: const EdgeInsets.only(right: 16, top: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: _buildBarChart(spots: spots, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart({required List<FlSpot> spots, required Color color}) {
    if (spots.isEmpty) {
      return const Center(
        child: Text("Tidak ada data", style: TextStyle(color: Colors.white54)),
      );
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY:
            spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) *
            1.2, // Beri margin 20% di atas
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => Colors.white,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                formatRupiah(rod.toY.toInt()),
                GoogleFonts.inter(color: color, fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    value.toInt().toString(),
                    style: const TextStyle(color: Colors.white60, fontSize: 10),
                  ),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: spots.map((spot) {
          return BarChartGroupData(
            x: spot.x.toInt(),
            barRods: [
              BarChartRodData(
                toY: spot.y,
                color: color,
                width: 16,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY:
                      spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) *
                      1.2,
                  color: color.withOpacity(0.05),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDetailCard({
    required String label,
    required String amount,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: appWhite,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                amount,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
