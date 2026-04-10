import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.fieldController,
    this.hidden = false,
    this.type,
  });

  final String label;
  final String hint;
  final TextEditingController? fieldController;
  final bool hidden;
  final TextInputType? type;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.hidden;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Label di luar TextField agar lebih rapi
        Text(
          widget.label,
          style: GoogleFonts.inter(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),

        // 2. Input Field
        TextField(
          obscureText: _obscureText,
          controller: widget.fieldController,
          keyboardType: widget.type,
          style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white.withOpacity(
              0.05,
            ), // Latar belakang gelap lembut
            hintText: widget.hint,
            hintStyle: GoogleFonts.inter(color: Colors.white24, fontSize: 15),

            // Icon Mata untuk Password
            suffixIcon: widget.hidden
                ? IconButton(
                    onPressed: () =>
                        setState(() => _obscureText = !_obscureText),
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.white38,
                      size: 20,
                    ),
                  )
                : null,

            // Border saat tidak aktif
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),

            // Border saat ditekan (Focus)
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Colors.greenAccent,
                width: 1.5,
              ),
            ),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
