import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hm_tracker/app/widget/text_field.dart';
import 'package:hm_tracker/constants/color.dart';

import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  SignupView({super.key});

  final TextEditingController _nameC = new TextEditingController();
  final TextEditingController _emailC = new TextEditingController();
  final TextEditingController _usernameC = new TextEditingController();
  final TextEditingController _passwordC = new TextEditingController();
  final TextEditingController _passwordConfirmationC =
      new TextEditingController();
  final _signUpC = Get.find<SignupController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CustomTextField(
                    label: "Nama Lengkap",
                    hint: 'John Doe',
                    fieldController: _nameC,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    label: "Username",
                    hint: 'johndoe',
                    fieldController: _usernameC,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    label: "Email",
                    hint: "johndoe@gmail.com",
                    fieldController: _emailC,
                  ),

                  const SizedBox(height: 10),
                  CustomTextField(
                    label: "Kata Sandi",
                    hint: "*****",
                    fieldController: _passwordC,
                    hidden: true,
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    label: "Konfirmasi Kata Sandi",
                    hint: "*****",
                    fieldController: _passwordConfirmationC,
                    hidden: true,
                  ),

                  SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      _signUpC.register(
                        name: _nameC.text,
                        email: _emailC.text,
                        password: _passwordC.text,
                        confirmationPassword: _passwordConfirmationC.text,
                        username: _usernameC.text,
                      );
                    },
                    child: Container(
                      child: Center(
                        child: Obx(
                          () => Text(
                            _signUpC.isLoading.value == true
                                ? "Mohon tunggu sebentar..."
                                : "Daftar",
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
                          "Anda  memiliki akun?",

                          style: TextStyle(fontSize: 12, color: appWhite),
                        ),
                        SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => Get.offNamed('/signin'),
                          child: Text(
                            "Masuk",
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
