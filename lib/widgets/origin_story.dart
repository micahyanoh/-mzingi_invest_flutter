import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'reveal.dart';

/// A brief brand-history section explaining where the name "M-Zingi" comes
/// from, paired with a slow, ambient rotating "cycle" mark that visually
/// echoes the idea of money and harvests going round and round.
class OriginStorySection extends StatelessWidget {
  final bool isWide;
  const OriginStorySection({super.key, required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.navGreen,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: isWide ? 72 : 48,
      ),
      child: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(flex: 2, child: _RotatingRing(size: 220)),
                const SizedBox(width: 56),
                Expanded(flex: 3, child: _StoryText()),
              ],
            )
          : Column(
              children: [
                const _RotatingRing(size: 160),
                const SizedBox(height: 32),
                const _StoryText(),
              ],
            ),
    );
  }
}

class _StoryText extends StatelessWidget {
  const _StoryText();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Eyebrow('Our Name'),
        const SizedBox(height: 10),
        Text('Why "M-Zingi"?',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white)),
        const SizedBox(height: 16),
        Reveal(
          child: Text(
            '"Zingi" comes from the Swahili verb "kuzunguka" — to go '
            'round, to circle back. It\'s the same root you\'ll hear in '
            '"zunguka" (turn around) and "mzunguko" (a cycle or rotation).',
            style: const TextStyle(color: Colors.white70, fontSize: 14.5, height: 1.6),
          ),
        ),
        const SizedBox(height: 14),
        Reveal(
          delay: const Duration(milliseconds: 90),
          child: Text(
            'We paired it with the familiar "M-" of Kenyan mobile money — '
            'M-Pesa, M-Shwari, M-Kopa — because that\'s exactly how capital '
            'moves here: a phone, an escrow, a harvest, a payout.',
            style: const TextStyle(color: Colors.white70, fontSize: 14.5, height: 1.6),
          ),
        ),
        const SizedBox(height: 14),
        Reveal(
          delay: const Duration(milliseconds: 180),
          child: Text(
            'Your KES 100 doesn\'t sit still. It funds a planting season, '
            'comes back with a harvest, and goes out again — a loop that '
            'keeps turning, one cycle at a time. That loop is the whole '
            'idea behind M-Zingi Invest.',
            style: const TextStyle(color: Colors.white70, fontSize: 14.5, height: 1.6),
          ),
        ),
      ],
    );
  }
}

/// A ring of small dots, each fading in turn as the ring slowly rotates —
/// a gentle, continuous "money going round" motion motif.
class _RotatingRing extends StatefulWidget {
  final double size;
  const _RotatingRing({required this.size});

  @override
  State<_RotatingRing> createState() => _RotatingRingState();
}

class _RotatingRingState extends State<_RotatingRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.of(context).disableAnimations) {
      _controller.value = 0;
    } else {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: Size.square(widget.size),
          painter: _RingPainter(rotation: _controller.value * 2 * math.pi),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  final double rotation;
  _RingPainter({required this.rotation});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 14;
    const dotCount = 14;

    for (int i = 0; i < dotCount; i++) {
      final angle = rotation + (2 * math.pi * i / dotCount);
      final offset = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      // Trailing fade: dots near the "head" of the sweep are brighter.
      final fade = (0.25 + 0.75 * (i / dotCount));
      canvas.drawCircle(
        offset,
        3.2,
        Paint()..color = Palette.gold.withValues(alpha: 0.25 + 0.6 * fade * 0.6),
      );
    }

    canvas.drawCircle(
      center,
      radius * 0.55,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.06)
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      center,
      radius * 0.55,
      Paint()
        ..color = Palette.gold.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );

    final iconPainter = TextPainter(
      text: const TextSpan(
        text: '🐝',
        style: TextStyle(fontSize: 30),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    iconPainter.paint(
      canvas,
      Offset(center.dx - iconPainter.width / 2, center.dy - iconPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.rotation != rotation;
}
