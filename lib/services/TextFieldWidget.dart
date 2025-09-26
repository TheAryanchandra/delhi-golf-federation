import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Blocks emoji characters (but allows normal characters).
/// Blocks all emojis (including new Unicode ones).
class NoEmojiFormatter extends TextInputFormatter {
  static final _emojiRegex = RegExp(
    r'[\u{1F300}-\u{1F6FF}]|' // Misc Symbols & Pictographs, Transport & Map
    r'[\u{1F900}-\u{1F9FF}]|' // Supplemental Symbols & Pictographs
    r'[\u{1FA70}-\u{1FAFF}]|' // Symbols & Pictographs Extended-A
    r'[\u{2600}-\u{26FF}]|'   // Misc symbols
    r'[\u{2700}-\u{27BF}]|'   // Dingbats
    r'[\u{1F1E6}-\u{1F1FF}]', // Flags
    unicode: true,
  );

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.replaceAll(_emojiRegex, '');
    final cursorPosition = newValue.selection;

    return TextEditingValue(
      text: newText,
      selection: cursorPosition.copyWith(
        baseOffset: newText.length < cursorPosition.baseOffset
            ? newText.length
            : cursorPosition.baseOffset,
        extentOffset: newText.length < cursorPosition.extentOffset
            ? newText.length
            : cursorPosition.extentOffset,
      ),
    );
  }
}

/// Blocks emoji and also blocks non-allowed special characters
/// (useful for strict fields like mobile / ids).
class NoEmojiStrictFormatter extends TextInputFormatter {
  static final _strictRegex = RegExp(r'^[A-Za-z0-9@._\-\s]*$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (!_strictRegex.hasMatch(newValue.text)) {
      return oldValue; // reject disallowed characters
    }
    return newValue;
  }
}

class GlobalTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool autoCorrect;
  final TextCapitalization textCapitalization;
  final int? maxLength;
  final String? prefixText;
  final TextStyle? prefixStyle;
  final IconData? prefixIcon;
  final int? maxLine;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  const GlobalTextField({
    Key? key,
    this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.autoCorrect = true,
    this.textCapitalization = TextCapitalization.none,
    this.maxLength,
    this.prefixText,
    this.prefixStyle,
    this.prefixIcon,
    this.maxLine,
    this.validator,
    this.suffixIcon,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fieldLabel = (hint ?? '').toLowerCase();
    final isNameOrEmail =
        fieldLabel.contains('name') || fieldLabel.contains('email');

    final appliedInputFormatters = <TextInputFormatter>[
      NoEmojiFormatter(),
      if (!isNameOrEmail) NoEmojiStrictFormatter(),
      ...?inputFormatters,
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        autocorrect: autoCorrect,
        textCapitalization: textCapitalization,
        maxLength: maxLength,
        maxLines: maxLine ?? 1,
        validator: validator,
        inputFormatters: appliedInputFormatters,
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: hint,
          labelText: hint,
          prefixText: prefixText,
          prefixStyle: prefixStyle,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: Colors.grey)
              : null,
          border: InputBorder.none,
          counterText: "",
          floatingLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
      ),
    );
  }
}
