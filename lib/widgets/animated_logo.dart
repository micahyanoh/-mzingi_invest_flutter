import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// The deck's circular sun/leaf mark, brought to life:
/// on mount it draws itself on (stroke reveal), then settles into a slow,
/// ambient breathing glow. This is the app's one signature motion moment —
/// used large on the landing hero and small in the nav bar.
class AnimatedLogoMark extends StatefulWidget {
  final double size;
  const AnimatedLogoMark({super.key, this.size = 64});

  @override
  State<AnimatedLogoMark> createState() => _AnimatedLogoMarkState();
}

class _AnimatedLogoMarkState extends State<AnimatedLogoMark>
    with TickerProviderStateMixin {
  late final AnimationController _drawController;
  late final AnimationController _breatheController;

  @override
  void initState() {
    super.initState();
    _drawController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _drawController.dispose();
    _breatheController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_drawController, _breatheController]),
      builder: (context, _) {
        return CustomPaint(
          size: Size.square(widget.size),
          painter: _LogoPainter(
            drawProgress: Curves.easeOutCubic.transform(_drawController.value),
            glow: _breatheController.value,
          ),
        );
      },
    );
  }
}

class _LogoPainter extends CustomPainter {
  final double drawProgress; // 0..1 stroke reveal
  final double glow; // 0..1 ambient pulse

  _LogoPainter({required this.drawProgress, required this.glow});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Ambient glow ring
    final glowPaint = Paint()
      ..color = Palette.gold.withValues(alpha: 0.15 + 0.15 * glow)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * (1.06 + 0.05 * glow), glowPaint);

    // Base disc, revealed via a sweep arc so it feels "drawn"
    final discPaint = Paint()
      ..color = Palette.gold
      ..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * drawProgress,
      true,
      discPaint,
    );

    // Sprouting leaf notch (dark wedge), fades/grows in after the disc
    final leafProgress = (drawProgress - 0.5).clamp(0.0, 0.5) * 2;
    if (leafProgress > 0) {
      final leafPaint = Paint()
        ..color = Palette.navGreen.withValues(alpha: leafProgress)
        ..style = PaintingStyle.fill;
      final path = Path()
        ..moveTo(center.dx + radius * 0.15, center.dy + radius * 0.85)
        ..quadraticBezierTo(
          center.dx + radius * 0.85,
          center.dy + radius * 0.75,
          center.dx + radius * 0.7,
          center.dy - radius * 0.1,
        )
        ..quadraticBezierTo(
          center.dx + radius * 0.15,
          center.dy + radius * 0.1,
          center.dx + radius * 0.15,
          center.dy + radius * 0.85,
        )
        ..close();
      canvas.drawPath(path, leafPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LogoPainter oldDelegate) {
    return oldDelegate.drawProgress != drawProgress ||
        oldDelegate.glow != glow;
  }
}
