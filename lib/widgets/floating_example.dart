import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FloatingExample extends StatelessWidget {
  final String text;
  final AnimationController controller;
  final double start;
  final double end;
  final double verticalPosition;
  final VoidCallback onTap;

  const FloatingExample({
    super.key,
    required this.text,
    required this.controller,
    required this.start,
    required this.end,
    required this.verticalPosition,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // Create curved animation that loops smoothly
        final Animation<double> animation = CurvedAnimation(
          parent: controller,
          curve: Interval(start, end, curve: Curves.easeInOut),
        );

        // Calculate horizontal position based on animation value
        // Ensure the position is calculated correctly for all screen sizes
        final double position = animation.value;
        final double horizontalPosition =
            (position * (screenWidth + 300)) - 150;

        // Only render if it's actually on-screen or close to it
        if (horizontalPosition < -200 ||
            horizontalPosition > screenWidth + 50) {
          return const SizedBox.shrink(); // Don't render if off-screen
        }

        return Positioned(
          left: horizontalPosition,
          top: verticalPosition,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
          ),
        );
      },
    );
  }
}
