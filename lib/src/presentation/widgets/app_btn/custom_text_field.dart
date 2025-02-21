import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final PhosphorIconData? prefixIcon;
  final TextEditingController textEditingController;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatter;
  final bool? readOnly;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    required this.textEditingController,
    this.keyboardType,
    this.inputFormatter,
    this.readOnly,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly ?? false,
      inputFormatters: inputFormatter,
      onChanged: (value) {
        if (onChanged != null) {
          onChanged!(value);
        }
      },
      keyboardType: keyboardType,
      controller: textEditingController,
      decoration: InputDecoration(
        prefixIcon: Container(
          padding: const EdgeInsets.only(right: 8, bottom: 8),
          child: Icon(
            prefixIcon,
            size: 20,
          ),
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.urbanist(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF010029),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF000000),
          ),
        ),
      ),
    );
  }
}
