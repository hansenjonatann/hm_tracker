import 'package:get/get.dart';

import '../modules/expense/bindings/expense_binding.dart';
import '../modules/expense/views/expense_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/income/bindings/income_binding.dart';
import '../modules/income/views/income_view.dart';
import '../modules/savings/bindings/savings_binding.dart';
import '../modules/savings/views/savings_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/signin/bindings/signin_binding.dart';
import '../modules/signin/views/signin_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../widget/main_page.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SIGNIN;

  static final routes = [
    GetPage(name: _Paths.HOME, page: () => HomeView(), binding: HomeBinding()),
    GetPage(
      name: _Paths.SIGNIN,
      page: () => SigninView(),
      binding: SigninBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.INCOME,
      page: () => IncomeView(),
      binding: IncomeBinding(),
    ),
    GetPage(
      name: _Paths.EXPENSE,
      page: () => ExpenseView(),
      binding: ExpenseBinding(),
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => const MainPage(), // Ini widget yang pakai PersistentTabView
      bindings: [HomeBinding(), IncomeBinding(), ExpenseBinding()],
    ),
    GetPage(
      name: _Paths.SAVINGS,
      page: () => SavingsView(),
      binding: SavingsBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}
