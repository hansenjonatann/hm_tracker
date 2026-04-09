import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm_tracker/app/modules/expense/controllers/expense_controller.dart';
import 'package:hm_tracker/app/modules/expense/views/expense_view.dart';
import 'package:hm_tracker/app/modules/home/controllers/home_controller.dart';
import 'package:hm_tracker/app/modules/home/views/home_view.dart';
import 'package:hm_tracker/app/modules/income/controllers/income_controller.dart';
import 'package:hm_tracker/app/modules/income/views/income_view.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:hm_tracker/constants/color.dart';

// Import halaman-halaman kamu di sini
// import 'package:hm_tracker/screens/home_screen.dart';
// import 'package:hm_tracker/screens/income_screen.dart';
// import 'package:hm_tracker/screens/expense_screen.dart';

class CustomBottomNavbar extends StatelessWidget {
  CustomBottomNavbar({super.key});

  final incomeController = Get.put(IncomeController());
  final expenseController = Get.put(ExpenseController());
  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: [
        PersistentTabConfig(
          screen: HomeView(),
          item: ItemConfig(
            icon: const Icon(Icons.home),
            title: "Home",
            activeForegroundColor: primary,
            inactiveForegroundColor: Colors.grey,
          ),
        ),
        PersistentTabConfig(
          screen: IncomeView(), // Ganti dengan IncomeScreen()
          item: ItemConfig(
            icon: const Icon(Icons.south_west),
            title: "Pemasukan",
            activeForegroundColor: primary,
            inactiveForegroundColor: Colors.grey,
          ),
        ),
        PersistentTabConfig(
          screen: ExpenseView(), // Ganti dengan ExpenseScreen()
          item: ItemConfig(
            icon: const Icon(Icons.north_east),
            title: "Pengeluaran",
            activeForegroundColor: primary,
            inactiveForegroundColor: Colors.grey,
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) =>
          Style2BottomNavBar(navBarConfig: navBarConfig),
    );
  }
}
