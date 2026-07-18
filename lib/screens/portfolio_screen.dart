import 'package:flutter/material.dart';
import '../data/mock_farms.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_progress_bar.dart';
import '../widgets/count_up.dart';
import '../widgets/reveal.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    final holdings = mockFarms.take(3).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 20, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Eyebrow('My Investments', color: Palette.deepGreen),
          const SizedBox(height: 8),
          Text('Your Portfolio', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 28),
          isWide
              ? IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(flex: 2, child: _SummaryCard()),
                      const SizedBox(width: 24),
                      Expanded(flex: 3, child: _GrowthChartCard()),
                    ],
                  ),
                )
              : Column(
                  children: const [
                    _SummaryCard(),
                    SizedBox(height: 20),
                    _GrowthChartCard(),
                  ],
                ),
          const SizedBox(height: 32),
          Text('Active Holdings', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          for (int i = 0; i < holdings.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Reveal(
                delay: Duration(milliseconds: 100 * i),
                child: _HoldingTile(
                  name: holdings[i].name,
                  weeks: holdings[i].weeks,
                  fraction: holdings[i].fundedFraction,
                  invested: 100 + (i * 400),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard();

  @override
  Widget build(BuildContext context) {
    return Reveal(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Palette.deepGreen,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('TOTAL INVESTED',
                style: TextStyle(color: Colors.white54, fontSize: 12, letterSpacing: 1)),
            const SizedBox(height: 8),
            const CountUpText(
              '2400',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 32),
            ),
            const SizedBox(height: 4),
            const Text('KES across 3 active farms',
                style: TextStyle(color: Colors.white54, fontSize: 12.5)),
            const SizedBox(height: 24),
            const Divider(color: Colors.white24),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Returns paid to date',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                CountUpText(
                  'KES 4,200',
                  delay: const Duration(milliseconds: 200),
                  style: const TextStyle(color: Palette.gold, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Next payout expected',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                const Text('In 9 days',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GrowthChartCard extends StatelessWidget {
  const _GrowthChartCard();

  @override
  Widget build(BuildContext context) {
    return Reveal(
      delay: const Duration(milliseconds: 120),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Palette.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Palette.ink.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Portfolio Value Over Time',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(height: 4),
            const Text('Last 6 months, illustrative',
                style: TextStyle(color: Palette.muted, fontSize: 12.5)),
            const SizedBox(height: 20),
            const SizedBox(
              height: 160,
              width: double.infinity,
              child: _AnimatedGrowthChart(
                values: [0.15, 0.28, 0.24, 0.42, 0.58, 0.52, 0.78],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A minimal, dependency-free line chart: draws its path on with
/// [PathMetric] so the trend line animates in like ink on paper.
class _AnimatedGrowthChart extends StatefulWidget {
  final List<double> values; // each 0..1
  const _AnimatedGrowthChart({required this.values});

  @override
  State<_AnimatedGrowthChart> createState() => _AnimatedGrowthChartState();
}

class _AnimatedGrowthChartState extends State<_AnimatedGrowthChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _controller.forward();
    });
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
          size: Size.infinite,
          painter: _ChartPainter(
            values: widget.values,
            progress: Curves.easeOutCubic.transform(_controller.value),
          ),
        );
      },
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<double> values;
  final double progress;
  _ChartPainter({required this.values, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final points = <Offset>[
      for (int i = 0; i < values.length; i++)
        Offset(
          size.width * (i / (values.length - 1)),
          size.height * (1 - values[i]),
        ),
    ];

    // Smooth-ish path through the points
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final mid = Offset(
        (points[i].dx + points[i + 1].dx) / 2,
        (points[i].dy + points[i + 1].dy) / 2,
      );
      path.quadraticBezierTo(points[i].dx, points[i].dy, mid.dx, mid.dy);
    }
    path.lineTo(points.last.dx, points.last.dy);

    // Reveal only the portion of the path up to `progress`
    final metrics = path.computeMetrics().toList();
    final revealPath = Path();
    for (final metric in metrics) {
      revealPath.addPath(
        metric.extractPath(0, metric.length * progress),
        Offset.zero,
      );
    }

    // Fill under the revealed line
    if (progress > 0) {
      final fillPath = Path.from(revealPath)
        ..lineTo(size.width * progress, size.height)
        ..lineTo(0, size.height)
        ..close();
      canvas.drawPath(
        fillPath,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Palette.gold.withValues(alpha: 0.35),
              Palette.gold.withValues(alpha: 0.02),
            ],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
      );
    }

    canvas.drawPath(
      revealPath,
      Paint()
        ..color = Palette.deepGreen
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Leading dot at the animated tip
    if (progress > 0.01) {
      final tipMetric = metrics.first;
      final tangent = tipMetric.getTangentForOffset(tipMetric.length * progress);
      if (tangent != null) {
        canvas.drawCircle(tangent.position, 5, Paint()..color = Palette.gold);
        canvas.drawCircle(
          tangent.position,
          5,
          Paint()
            ..color = Palette.deepGreen
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _HoldingTile extends StatelessWidget {
  final String name;
  final int weeks;
  final double fraction;
  final int invested;

  const _HoldingTile({
    required this.name,
    required this.weeks,
    required this.fraction,
    required this.invested,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Palette.paleGreen, width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Palette.paleGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.eco, color: Palette.deepGreen),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
                    CountUpText(
                      'KES $invested',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                AnimatedProgressBar(fraction: fraction, height: 6),
                const SizedBox(height: 6),
                Text('Week ${(fraction * weeks).round()} of $weeks',
                    style: const TextStyle(color: Palette.muted, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
