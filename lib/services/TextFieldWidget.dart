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
    // Strip all emojis (instead of rejecting whole input).
    final newText = newValue.text.replaceAll(_emojiRegex, '');
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
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
    return newValue; // emoji already blocked by NoEmojiFormatter
  }
}


class GlobalTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword; // kept for compatibility, you can wire toggle logic
  final bool autoCorrect;
  final TextCapitalization textCapitalization; // <-- added
  final int? maxLength;
  final bool obscureText;
  final String? prefixText;
  final TextStyle? prefixStyle;
  final IconData? prefixIcon;
  final int? maxLine;
  final Widget? suffixIcon;
  final InputBorder? border;
  final VoidCallback? onTogglePassword;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final InputDecoration? decoration; // <-- added: accept custom decoration

  const GlobalTextField({
    Key? key,
    this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.autoCorrect = true,
    this.textCapitalization = TextCapitalization.none,
    this.maxLength,
    this.obscureText = false,
    this.onTogglePassword,
    this.prefixText,
    this.prefixStyle,
    this.prefixIcon,
    this.maxLine,
    this.validator,
    this.suffixIcon,
    this.border,
    this.inputFormatters,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fieldLabel = (hint ?? decoration?.hintText ?? decoration?.labelText ?? '').toLowerCase();
    final isNameOrEmail = fieldLabel.contains('name') || fieldLabel.contains('email');

   final appliedInputFormatters = <TextInputFormatter>[
  NoEmojiFormatter(), // always block emoji
  if (!isNameOrEmail) NoEmojiStrictFormatter(), // strict for other fields
  ...?inputFormatters,
];


    final InputDecoration effectiveDecoration = decoration != null
        ? decoration!.copyWith(counterText: "")
        : InputDecoration(
            labelText: hint,
            prefixText: prefixText,
            prefixStyle: prefixStyle,
            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(5),
            //   borderSide: BorderSide(color: ColorConstants.grey600Color, width: 1),
            // ),
            // enabledBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(5),
            //   borderSide: BorderSide(color: ColorConstants.grey600Color, width: 1),
            // ),
            // focusedBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(5),
            //   borderSide: BorderSide(color: ColorConstants.buttonBlueColor, width: 1),
            // ),
            // errorBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(5),
            //   borderSide: BorderSide(color: ColorConstants.redColor, width: 1),
            // ),
            floatingLabelStyle: TextStyle(
              // color: ColorConstants.buttonBlueColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            suffixIcon: suffixIcon,
            counterText: "",
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          );

   return TextFormField(
  controller: controller,
  keyboardType: keyboardType,
  obscureText: obscureText,
  autocorrect: autoCorrect,
  textCapitalization: textCapitalization,
  maxLength: maxLength,
  maxLines: maxLine ?? 1,
  validator: validator,
  inputFormatters: appliedInputFormatters,
  // cursorColor: ColorConstants.blackColor,
  onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
  // ❌ Remove auto-trim from here
  style: TextStyle(
    // color: ColorConstants.blackColor,
    fontWeight: FontWeight.w600,
    fontSize: 14,
  ),
  decoration: effectiveDecoration,
);

  }
}
