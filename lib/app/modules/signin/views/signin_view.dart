import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hm_tracker/app/controllers/auth_controller.dart';
import 'package:hm_tracker/app/widget/text_field.dart';
import 'package:hm_tracker/constants/color.dart';

import '../controllers/signin_controller.dart';

class SigninView extends GetView<SigninController> {
  SigninView({super.key});
  final signInC = Get.find<AuthController>();
  final TextEditingController _usernameC = new TextEditingController();
  final TextEditingController _passwordC = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,

            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                    label: "Username",
                    hint: "username",
                    fieldController: _usernameC,
                  ),
                  CustomTextField(
                    label: "Password",
                    hint: "password",
                    hidden: true,
                    fieldController: _passwordC,
                  ),

                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      signInC.login(
                        username: _usernameC.text,
                        password: _passwordC.text,
                      );
                    },
                    child: Container(
                      child: Center(
                        child: Obx(
                          () => Text(
                            signInC.isLoading.value == true
                                ? "Mohon tunggu sebentar..."
                                : "Masuk",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      height: 50,
                      decoration: BoxDecoration(color: secondary),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Anda tidak memiliki akun?",
                          style: TextStyle(fontSize: 12, color: appWhite),
                        ),
                        SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => Get.offNamed('/signup'),
                          child: Text(
                            "Daftar",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: appWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
