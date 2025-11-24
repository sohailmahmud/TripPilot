import 'package:flutter/material.dart';

/// Reusable search input field widget with optional date picker
class SearchInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon;
  final bool readOnly;
  final TextInputType keyboardType;
  final VoidCallback? onDatePickerTap;

  const SearchInputField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.onDatePickerTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: onDatePickerTap != null
            ? IconButton(
                icon: const Icon(Icons.date_range),
                onPressed: onDatePickerTap,
              )
            : null,
      ),
    );
  }
}
