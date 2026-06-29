import 'package:flutter/material.dart';
import '../core/colors.dart';

enum MascotMood { sleeping, happy, excited, neutral }

class MascotWidget extends StatelessWidget {
  final double size;
  final MascotMood mood;
  final String? accessoryHat;

  const MascotWidget({
    super.key,
    this.size = 100,
    this.mood = MascotMood.happy,
    this.accessoryHat,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _MascotPainter(mood: mood),
      ),
    );
  }
}

class _MascotPainter extends CustomPainter {
  final MascotMood mood;

  _MascotPainter({required this.mood});

  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height * 0.62;
    final double r  = size.width * 0.30;

    final bodyPaint   = Paint()..color = AppColors.purple;
    final innerPaint  = Paint()..color = AppColors.purpleLight;
    final eyePaint    = Paint()..color = const Color(0xFF1A0A3E);
    final whitePaint  = Paint()..color = Colors.white;
    final nosePaint   = Paint()..color = AppColors.purplePale;
    final shadowPaint = Paint()..color = AppColors.card;
    final zPaint      = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.fill;

    // Shadow
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, size.height * 0.92), width: r * 1.8, height: r * 0.4),
      shadowPaint..color = AppColors.card2,
    );

    // Ears
    final earOffset = r * 0.55;
    _drawEar(canvas, Offset(cx - earOffset, cy - r * 1.4), r * 0.28, r * 0.72, -0.18, bodyPaint, innerPaint);
    _drawEar(canvas, Offset(cx + earOffset, cy - r * 1.4), r * 0.28, r * 0.72, 0.18, bodyPaint, innerPaint);

    // Body
    canvas.drawCircle(Offset(cx, cy), r, bodyPaint);

    // Eyes
    if (mood == MascotMood.sleeping) {
      _drawSleepingEyes(canvas, cx, cy, r, eyePaint);
    } else {
      _drawOpenEyes(canvas, cx, cy, r, eyePaint, whitePaint);
    }

    // Nose
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + r * 0.22), width: r * 0.26, height: r * 0.16),
      nosePaint,
    );

    // Mouth
    final mouthPaint = Paint()
      ..color = AppColors.textMuted
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.05
      ..strokeCap = StrokeCap.round;

    if (mood == MascotMood.happy || mood == MascotMood.excited) {
      final path = Path()
        ..moveTo(cx - r * 0.18, cy + r * 0.34)
        ..quadraticBezierTo(cx, cy + r * 0.44, cx + r * 0.18, cy + r * 0.34);
      canvas.drawPath(path, mouthPaint);
    } else {
      canvas.drawLine(
        Offset(cx - r * 0.12, cy + r * 0.36),
        Offset(cx + r * 0.12, cy + r * 0.36),
        mouthPaint,
      );
    }

    // Cheek blush
    if (mood == MascotMood.happy || mood == MascotMood.excited) {
      final blushPaint = Paint()..color = AppColors.pink.withValues(alpha: 0.25);
      canvas.drawCircle(Offset(cx - r * 0.52, cy + r * 0.12), r * 0.18, blushPaint);
      canvas.drawCircle(Offset(cx + r * 0.52, cy + r * 0.12), r * 0.18, blushPaint);
    }

    // Sleeping Z letters
    if (mood == MascotMood.sleeping) {
      _drawZ(canvas, Offset(cx + r * 0.7, cy - r * 0.5), r * 0.22, zPaint);
      _drawZ(canvas, Offset(cx + r * 0.9, cy - r * 0.85), r * 0.16, zPaint);
      _drawZ(canvas, Offset(cx + r * 1.05, cy - r * 1.1), r * 0.11, zPaint);
    }

    // Sparkle for excited
    if (mood == MascotMood.excited) {
      _drawSparkle(canvas, Offset(cx + r * 0.7, cy - r * 0.7), r * 0.08, zPaint);
    }
  }

  void _drawEar(Canvas canvas, Offset center, double rx, double ry, double rotation,
      Paint outer, Paint inner) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: rx * 2, height: ry * 2), outer);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(0, ry * 0.1), width: rx * 1.1, height: ry * 1.4),
      inner,
    );
    canvas.restore();
  }

  void _drawOpenEyes(Canvas canvas, double cx, double cy, double r,
      Paint eyePaint, Paint whitePaint) {
    final eyeY  = cy - r * 0.1;
    final eyeRx = r * 0.19;
    canvas.drawCircle(Offset(cx - r * 0.32, eyeY), eyeRx, eyePaint);
    canvas.drawCircle(Offset(cx + r * 0.32, eyeY), eyeRx, eyePaint);
    canvas.drawCircle(Offset(cx - r * 0.27, eyeY - eyeRx * 0.2), eyeRx * 0.4, whitePaint);
    canvas.drawCircle(Offset(cx + r * 0.37, eyeY - eyeRx * 0.2), eyeRx * 0.4, whitePaint);
  }

  void _drawSleepingEyes(Canvas canvas, double cx, double cy, double r, Paint paint) {
    final eyeY = cy - r * 0.1;
    final linePaint = Paint()
      ..color = const Color(0xFF1A0A3E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.1
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx - r * 0.32, eyeY), width: r * 0.36, height: r * 0.36),
      3.14, 3.14, false, linePaint,
    );
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx + r * 0.32, eyeY), width: r * 0.36, height: r * 0.36),
      3.14, 3.14, false, linePaint,
    );
  }

  void _drawZ(Canvas canvas, Offset pos, double s, Paint paint) {
    final tp = TextPainter(
      text: TextSpan(
        text: 'Z',
        style: TextStyle(
          color: AppColors.gold,
          fontSize: s * 2.5,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, pos);
  }

  void _drawSparkle(Canvas canvas, Offset pos, double r, Paint paint) {
    for (int i = 0; i < 4; i++) {
      final angle = i * 3.14159 / 2;
      final x2 = pos.dx + r * 2 * (i % 2 == 0 ? (i < 2 ? 1 : -1) : 0);
      final y2 = pos.dy + r * 2 * (i % 2 == 1 ? (i < 3 ? 1 : -1) : 0);
      canvas.drawLine(pos, Offset(x2, y2),
          paint..style = PaintingStyle.stroke..strokeWidth = r * 0.8..strokeCap = StrokeCap.round);
    }
  }

  @override
  bool shouldRepaint(_MascotPainter oldDelegate) => oldDelegate.mood != mood;
}
