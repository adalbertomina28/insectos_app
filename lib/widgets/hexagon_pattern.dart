import 'package:flutter/material.dart';
import 'dart:math' as math;

class HexagonPattern extends CustomPainter {
  final Color color;
  final double size;
  final double spacing;

  HexagonPattern({
    required this.color,
    this.size = 30,
    this.spacing = 10,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final hexagonPath = Path();
    final double radius = this.size / 2;
    final double height = radius * math.sqrt(3);

    for (double y = -height; y < size.height + height; y += height * 1.5) {
      bool offset = false;
      for (double x = -radius; x < size.width + radius; x += (radius * 3) + spacing) {
        final double currentX = x + (offset ? radius * 1.5 : 0);
        drawHexagon(hexagonPath, currentX, y, radius);
        canvas.drawPath(hexagonPath, paint);
        hexagonPath.reset();
      }
      offset = !offset;
    }
  }

  void drawHexagon(Path path, double x, double y, double radius) {
    final double height = radius * math.sqrt(3);
    path.moveTo(x + radius * math.cos(0), y + radius * math.sin(0));

    for (int i = 1; i <= 6; i++) {
      final double angle = (i * 60) * math.pi / 180;
      path.lineTo(
        x + radius * math.cos(angle),
        y + radius * math.sin(angle),
      );
    }

    path.close();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
