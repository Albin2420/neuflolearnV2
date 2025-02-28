import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgressBarPainter extends CustomPainter {
  final double progress;
  final String text;

  ProgressBarPainter({required this.progress, required this.text});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = const Color(0xff02012A).withAlpha(128)
      ..style = PaintingStyle.fill;

    final Paint progressPaint = Paint()
      ..color = const Color(0xff02012A)
      ..style = PaintingStyle.fill;

    final double borderRadius = 10.0;

    // Background Bar
    RRect backgroundRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    // Draw background with border radius
    canvas.drawRRect(backgroundRRect, backgroundPaint);

    // Clip to ensure the progress bar follows the same rounded borders
    canvas.save();
    canvas.clipRRect(backgroundRRect);

    // Progress Bar
    final double progressHeight = size.height * progress;
    RRect progressRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          0, size.height - progressHeight, size.width, progressHeight),
      Radius.circular(borderRadius),
    );

    // Draw progress bar inside the clipped area
    canvas.drawRRect(progressRRect, progressPaint);

    canvas.restore(); // Restore canvas to remove clipping

    // Save the current canvas state before rotating
    canvas.save();
    canvas.rotate(-90 * 3.1416 / 180);

    // Text Formatting
    final TextSpan span = TextSpan(
      text: text,
      style: GoogleFonts.urbanist(
        color: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.w700,
      ),
    );
    final TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();

    final double textX = -(size.height) + 10;
    final double textY = (size.width - tp.height) / 2;

    log("x:$textX, y:$textY");

    tp.paint(canvas, Offset(textX, textY));

    // Restore the canvas after rotation
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Ensure repainting happens dynamically
  }
}
