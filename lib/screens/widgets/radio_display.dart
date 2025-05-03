import 'dart:math' as Math;

import 'package:flutter/material.dart';

// Helper for radians conversion
double cos(double angle) => Math.cos(angle);
double sin(double angle) => Math.sin(angle);

const startY = 15;
const endY = 25;
const posY = 40;

const minAngle = -2.35619; // -225° in radians
const maxAngle = 2.35619;  // 225° in radians

class TunerScalePainter extends CustomPainter {
  final double currentFrequency;
  final bool isActive;

  TunerScalePainter({required this.currentFrequency, required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw tuner scale
    final scalePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.grey[400]!
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, radius - 15, scalePaint);

    // Draw frequency markers
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 88; i <= 108; i += 2) {
      final angle = _frequencyToAngle(i.toDouble());
      final markerStart = Offset(
        center.dx + (radius - 25) * cos(angle),
        center.dy + (radius - 25) * sin(angle),
      );
      final markerEnd = Offset(
        center.dx + (radius - 15) * cos(angle),
        center.dy + (radius - 15) * sin(angle),
      );

      canvas.drawLine(
        markerStart,
        markerEnd,
        Paint()
          ..color = isActive ? Colors.black : Colors.grey
          ..strokeWidth = 2.0,
      );

      // Draw frequency text
      if (i % 4 == 0) {
        textPainter.text = TextSpan(
          text: '$i',
          style: TextStyle(
            color: isActive ? Colors.black : Colors.grey,
            fontSize: 12,
          ),
        );
        textPainter.layout();

        final textPosition = Offset(
          center.dx + (radius - posY) * cos(angle) - textPainter.width / 2,
          center.dy + (radius - posY) * sin(angle) - textPainter.height / 2,
        );

        textPainter.paint(canvas, textPosition);
      }
    }

    // Draw current frequency indicator
    final indicatorAngle = _frequencyToAngle(currentFrequency);
    final indicatorStart = Offset(
      center.dx + (radius - startY) * cos(indicatorAngle),
      center.dy + (radius - startY) * sin(indicatorAngle),
    );
    final indicatorEnd = Offset(
      center.dx + (radius - endY) * cos(indicatorAngle),
      center.dy + (radius - endY) * sin(indicatorAngle),
    );

    canvas.drawLine(
      indicatorStart,
      indicatorEnd,
      Paint()
        ..color = isActive ? Colors.red : Colors.grey
        ..strokeWidth = 3.0,
    );

    // Draw indicator dot
    canvas.drawCircle(
      indicatorEnd,
      3.0,
      Paint()..color = isActive ? Colors.red : Colors.grey,
    );
  }

  double _frequencyToAngle(double frequency) {
    // Map frequency (87.5 - 108.0) to angle (-135° to 135°)
    const minFreq = 87.5;
    const maxFreq = 108.0;

    return minAngle + (frequency - minFreq) * (maxAngle - minAngle) / (maxFreq - minFreq);
  }

  @override
  bool shouldRepaint(TunerScalePainter oldDelegate) {
    return oldDelegate.currentFrequency != currentFrequency ||
        oldDelegate.isActive != isActive;
  }
}

class PresetButton extends StatelessWidget {
  final double? frequency;
  final bool isActive;
  final VoidCallback? onPressed;

  const PresetButton({
    Key? key,
    required this.frequency,
    required this.isActive,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.grey[800],
          foregroundColor: isActive ? Colors.white : Colors.grey,
          minimumSize: const Size(60, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          frequency != null ? frequency!.toStringAsFixed(1) : '+',
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}