import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm_tracker/app/controllers/auth_controller.dart';
import 'package:hm_tracker/app/widget/text_field.dart';
import 'package:hm_tracker/constants/color.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final _authC = Get.find<AuthController>();

  final TextEditingController _nameC = new TextEditingController();
  final TextEditingController _emailC = new TextEditingController();
  final TextEditingController _usernameC = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary, // Background utama menggunakan warna primary
      appBar: AppBar(
        title: Text(
          "Edit Profil",
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Foto Profil
            Center(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: appWhite.withOpacity(0.2),
                        width: 4,
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 60,
                      backgroundColor: appWhite,
                      child: Icon(Icons.person, size: 80, color: primary),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: CircleAvatar(
                      backgroundColor:
                          Colors.tealAccent[400], // Warna aksen dari logo
                      radius: 18,
                      child: const Icon(
                        Icons.camera_alt,
                        size: 18,
                        color: primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Form Fields Container
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Obx(
                () => Column(
                  children: [
                    _buildDarkTextField(
                      controller: _nameC,
                      label: "Nama Lengkap",
                      hint: _authC.userProfile.value.name.toString(),
                    ),
                    const SizedBox(height: 20),
                    _buildDarkTextField(
                      controller: _emailC,
                      label: "Email",
                      hint: _authC.userProfile.value.email.toString(),
                    ),
                    const SizedBox(height: 20),
                    _buildDarkTextField(
                      controller: _usernameC,
                      label: "Nama Pengguna",
                      hint: '${_authC.userProfile.value.username}',
                    ),
                    const SizedBox(height: 50),

                    // Button Simpan (Warna Putih agar kontras dengan background)
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          _authC.updateProfile(
                            _nameC.text,
                            _emailC.text,
                            _usernameC.text,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondary,
                          foregroundColor: appWhite, // Warna teks tombol
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        child: Obx(
                          () => Text(
                            _authC.isLoading.value == true
                                ? "Sedang mengubah..."
                                : "UBAH",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDarkTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        CustomTextField(fieldController: controller, label: label, hint: hint),
      ],
    );
  }
}
