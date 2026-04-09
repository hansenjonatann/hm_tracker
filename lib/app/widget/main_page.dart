import 'package:flutter/material.dart';
import 'package:hm_tracker/app/modules/expense/views/expense_view.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:hm_tracker/constants/color.dart';
// Import view kamu
import 'package:hm_tracker/app/modules/home/views/home_view.dart';
import 'package:hm_tracker/app/modules/income/views/income_view.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: [
        _buildTab(HomeView(), Icons.grid_view_rounded, "Home"),

        _buildTab(
          IncomeView(),
          Icons.account_balance_wallet_rounded,
          "Pemasukan",
        ),
        // Tab tengah yang menonjol (Floating Action Button style)
        _buildTab(ExpenseView(), Icons.north_east, "Pengeluaran"),
        _buildTab(ExpenseView(), Icons.analytics_rounded, "Laporan"),
        _buildTab(ExpenseView(), Icons.analytics_rounded, "Laporan"),
        _buildTab(ExpenseView(), Icons.person_rounded, "Profil"),
      ],
      navBarBuilder: (navBarConfig) => Style2BottomNavBar(
        navBarConfig: navBarConfig,
        height: 70,
        navBarDecoration: NavBarDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
      ),
    );
  }

  PersistentTabConfig _buildTab(
    Widget screen,
    IconData icon,
    String title, {
    bool isCenter = false,
  }) {
    return PersistentTabConfig(
      screen: screen,
      item: ItemConfig(
        icon: Icon(icon, size: 24),
        title: title,
        // Gunakan primary color kamu untuk ikon aktif
        activeForegroundColor: appWhite,
        inactiveForegroundColor: Colors.grey,
        // Khusus Style 15, activeColorPrimary digunakan sebagai background lingkaran tengah
        activeColorSecondary: primary,
        textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }
}
