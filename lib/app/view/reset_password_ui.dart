import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm_tracker/app/controllers/auth_controller.dart';
import 'package:hm_tracker/app/widget/text_field.dart';
import 'package:hm_tracker/constants/color.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final _authC = Get.find<AuthController>();

  final TextEditingController _passwordC = new TextEditingController();
  final TextEditingController _confirmationPasswordC =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        title: Text(
          "Atur ulang kata sandi",
          style: GoogleFonts.inter(
            color: appWhite,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        backgroundColor:
            Colors.transparent, // Transparan agar menyatu dengan body
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: appWhite),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(15), child: _buildForm()),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        CustomTextField(
          fieldController: _passwordC,
          label: 'Kata Sandi',
          hint: '*****',
          hidden: true,
        ),
        const SizedBox(height: 10.0),
        CustomTextField(
          fieldController: _confirmationPasswordC,
          label: 'Konfirmasi kata sandi',
          hint: '******',
          hidden: true,
        ),
        const SizedBox(height: 10.0),
        InkWell(
          onTap: () => _authC.resetPassword(
            password: _passwordC.text,
            confirmationPassword: _confirmationPasswordC.text,
          ),
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Obx(
              () => _authC.isLoading.value == true
                  ? Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: appWhite),
                          const SizedBox(width: 8.0),
                          Text(
                            "Mengubah kata sandi...",
                            style: GoogleFonts.inter(color: appWhite),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Text(
                        "Ubah Kata Sandi",
                        style: GoogleFonts.inter(color: appWhite),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
