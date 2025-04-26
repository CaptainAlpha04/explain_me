import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FloatingExample extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const FloatingExample({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[400]!, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            text,
            style: GoogleFonts.gloriaHallelujah(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }
}
