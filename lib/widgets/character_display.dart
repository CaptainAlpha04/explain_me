import 'package:flutter/material.dart';
import '../models/theme_model.dart';

class CharacterDisplay extends StatelessWidget {
  final Character character;
  final ArtTheme theme;

  const CharacterDisplay({
    super.key,
    required this.character,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    // For now, we'll use a placeholder for the character image
    // In a real implementation, you would have actual images for each character in each art style
    return Column(
      children: [
        // Temporary hand-drawn cat image
        Container(
          height: 180,
          width: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey[300]!, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // This is a placeholder - you would replace this with actual character images
              Image.asset(
                'assets/images/pencil_cat.png',
                height: 160,
                width: 160,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to a custom drawn character if the asset isn't available yet
                  return CustomPaint(
                    size: const Size(160, 160),
                    painter: CatPainter(),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Character and art style info
        Text(
          '${character.name} - ${theme.name} Style',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}

// Custom painter to draw a simple cat since we don't have the actual assets yet
class CatPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final catBodyPath = Path()
      ..moveTo(size.width * 0.3, size.height * 0.4)
      ..quadraticBezierTo(size.width * 0.2, size.height * 0.6, size.width * 0.3,
          size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.9, size.width * 0.7,
          size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.8, size.height * 0.6, size.width * 0.7,
          size.height * 0.4)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.3, size.width * 0.3,
          size.height * 0.4);

    // Draw the cat's body
    canvas.drawPath(catBodyPath, paint);

    // Draw the cat's head
    canvas.drawCircle(
        Offset(size.width * 0.5, size.height * 0.4), size.width * 0.2, paint);

    // Draw the cat's ears
    final leftEarPath = Path()
      ..moveTo(size.width * 0.4, size.height * 0.3)
      ..lineTo(size.width * 0.35, size.height * 0.15)
      ..lineTo(size.width * 0.45, size.height * 0.25)
      ..close();

    final rightEarPath = Path()
      ..moveTo(size.width * 0.6, size.height * 0.3)
      ..lineTo(size.width * 0.65, size.height * 0.15)
      ..lineTo(size.width * 0.55, size.height * 0.25)
      ..close();

    canvas.drawPath(leftEarPath, paint);
    canvas.drawPath(rightEarPath, paint);

    // Draw the cat's eyes
    canvas.drawCircle(
        Offset(size.width * 0.4, size.height * 0.38), size.width * 0.03, paint);
    canvas.drawCircle(
        Offset(size.width * 0.6, size.height * 0.38), size.width * 0.03, paint);

    // Draw the cat's mouth (whiskers and smile)
    final smilePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Whiskers
    canvas.drawLine(Offset(size.width * 0.3, size.height * 0.45),
        Offset(size.width * 0.15, size.height * 0.4), smilePaint);
    canvas.drawLine(Offset(size.width * 0.3, size.height * 0.48),
        Offset(size.width * 0.15, size.height * 0.48), smilePaint);
    canvas.drawLine(Offset(size.width * 0.7, size.height * 0.45),
        Offset(size.width * 0.85, size.height * 0.4), smilePaint);
    canvas.drawLine(Offset(size.width * 0.7, size.height * 0.48),
        Offset(size.width * 0.85, size.height * 0.48), smilePaint);

    // Smile
    final smilePath = Path();
    smilePath.moveTo(size.width * 0.4, size.height * 0.5);
    smilePath.quadraticBezierTo(size.width * 0.5, size.height * 0.55,
        size.width * 0.6, size.height * 0.5);
    canvas.drawPath(smilePath, smilePaint);

    // Draw the cat's tail
    final tailPath = Path()
      ..moveTo(size.width * 0.7, size.height * 0.65)
      ..quadraticBezierTo(size.width * 0.8, size.height * 0.5, size.width * 0.7,
          size.height * 0.4);
    canvas.drawPath(tailPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
