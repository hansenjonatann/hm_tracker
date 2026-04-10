import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hm_tracker/app/controllers/auth_controller.dart';
import 'package:hm_tracker/app/view/edit_profile_ui.dart';
import 'package:hm_tracker/app/view/reset_password_ui.dart';
import 'package:hm_tracker/constants/color.dart';
import 'package:hm_tracker/utils/format-date.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({super.key});

  final _authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Center(
                  child: Container(
                    width: 100,
                    height: 100.0,
                    decoration: const BoxDecoration(
                      color: appWhite,

                      borderRadius: BorderRadius.all(Radius.circular(80)),
                    ),
                    child: Center(child: Icon(Icons.person, size: 40)),
                  ),
                ),
                const SizedBox(height: 12.0),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(
                        () => Text(
                          '@${_authC.userProfile.value.username}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: appWhite,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Get.to(() => EditProfileScreen());
                        },
                        icon: Icon(Icons.edit),
                        color: appWhite,
                        iconSize: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                const SizedBox(height: 30.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPersonalInformation(),
                      const SizedBox(height: 30.0),
                      _buildPrivacyDetails(),
                      const SizedBox(height: 30.0),
                      _buildAnotherSettings(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Informasi Personal",
          style: GoogleFonts.inter(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        Column(
          children: [
            const SizedBox(height: 10.0),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInformationCard(
                    'Nama',
                    _authC.userProfile.value.name.toString(),
                  ),
                  const SizedBox(height: 12.0),
                  _buildInformationCard(
                    'Nama Pengguna',
                    _authC.userProfile.value.username.toString(),
                  ),
                  const SizedBox(height: 12.0),
                  _buildInformationCard(
                    'Email',
                    _authC.userProfile.value.email.toString(),
                  ),
                  const SizedBox(height: 12.0),
                  _buildInformationCard(
                    'Akun dibuat Pada',
                    formatDate(_authC.userProfile.value.createdAt.toString()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrivacyDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Privasi & Keamanan",
          style: GoogleFonts.inter(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        Column(
          children: [
            const SizedBox(height: 10.0),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    onTap: () => Get.to(() => ResetPasswordScreen()),
                    contentPadding: EdgeInsets.all(0),
                    title: Text(
                      "Atur Ulang Kata Sandi ",
                      style: GoogleFonts.inter(color: appWhite, fontSize: 11),
                    ),
                    subtitle: Text(
                      "Klik disini untuk mengatur ulang kata sandi anda!",
                      style: GoogleFonts.inter(color: Colors.grey, fontSize: 9),
                    ),
                    leading: Container(
                      width: 30,
                      height: 30,

                      child: Center(child: Icon(Icons.lock, color: appWhite)),
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: Row(
                      children: [
                        Text(
                          "Atur Kode PIN  ",
                          style: GoogleFonts.inter(
                            color: appWhite,
                            fontSize: 11,
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 19,
                          decoration: BoxDecoration(
                            color: secondary,

                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'Segera Hadir!',
                              style: GoogleFonts.inter(
                                color: appWhite,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      "Klik disini untuk mengatur pin anda!",
                      style: GoogleFonts.inter(color: Colors.grey, fontSize: 9),
                    ),
                    leading: Container(
                      width: 30,
                      height: 30,

                      child: Center(child: Icon(Icons.pin, color: appWhite)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnotherSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Lainnya",
          style: GoogleFonts.inter(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        Column(
          children: [
            const SizedBox(height: 10.0),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: Text(
                      "Berikan Penilaian ",
                      style: GoogleFonts.inter(color: appWhite, fontSize: 11),
                    ),
                    subtitle: Text(
                      "Klik disini untuk memberikan nilai kepada aplikasi!",
                      style: GoogleFonts.inter(color: Colors.grey, fontSize: 9),
                    ),
                    leading: Container(
                      width: 30,
                      height: 30,

                      child: Center(
                        child: Icon(Icons.thumb_up, color: appWhite),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: Row(
                      children: [
                        Text(
                          "Versi Aplikasi ( 1.0 )",
                          style: GoogleFonts.inter(
                            color: appWhite,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      "",
                      style: GoogleFonts.inter(color: Colors.grey, fontSize: 9),
                    ),
                    leading: Container(
                      width: 30,
                      height: 30,

                      child: Center(
                        child: Icon(Icons.rate_review, color: appWhite),
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () => _authC.signOut(),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Row(
                        children: [
                          Text(
                            "Keluar",
                            style: GoogleFonts.inter(
                              color: appWhite,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        "Klik disini untuk keluar dari akun Anda!",
                        style: GoogleFonts.inter(
                          color: Colors.grey,
                          fontSize: 9,
                        ),
                      ),
                      leading: Container(
                        width: 30,
                        height: 30,

                        child: Center(
                          child: Icon(Icons.logout, color: appWhite),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInformationCard(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white38,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10.0),
        Text(
          '${value}',
          style: GoogleFonts.inter(
            color: appWhite,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
