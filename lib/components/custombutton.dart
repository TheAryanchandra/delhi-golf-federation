import 'package:flutter/material.dart';
import 'color_constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? textColor;
  final Color? backgroundColor; // ✅ added
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor = Colors.white,
    this.backgroundColor, // optional, defaults to ColorConstants.buttonColor
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? ColorConstants.buttonColor, // ✅ dynamic
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
