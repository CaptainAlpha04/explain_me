import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HandDrawnButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  const HandDrawnButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
  });

  @override
  State<HandDrawnButton> createState() => _HandDrawnButtonState();
}

class _HandDrawnButtonState extends State<HandDrawnButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: _isHovering
                ? (widget.backgroundColor ?? Colors.grey[200])!.withOpacity(0.9)
                : widget.backgroundColor ?? Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.grey[800]!,
              width: 2,
              style: BorderStyle.solid,
            ),
            boxShadow: _isHovering
                ? [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(1, 2),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
          ),
          child: Text(
            widget.text,
            style: GoogleFonts.gloriaHallelujah(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: widget.textColor ?? Colors.grey[800],
            ),
          ),
        ),
      ),
    );
  }
}
