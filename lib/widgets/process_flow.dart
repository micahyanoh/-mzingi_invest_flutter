import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProcessStep {
  final IconData icon;
  final String title;
  final String subtitle;
  const ProcessStep({required this.icon, required this.title, required this.subtitle});
}

/// A looping, self-animating diagram: a pulse of light travels along a
/// connecting line through each stage, highlighting the node it's passing.
/// This is the "watch the loop work" moment — illustrating the process
/// itself, not just revealing text on screen.
class ProcessFlowDiagram extends StatefulWidget {
  final List<ProcessStep> steps;
  final Duration cycleDuration;

  const ProcessFlowDiagram({
    super.key,
    required this.steps,
    this.cycleDuration = const Duration(seconds: 7),
  });

  @override
  State<ProcessFlowDiagram> createState() => _ProcessFlowDiagramState();
}

class _ProcessFlowDiagramState extends State<ProcessFlowDiagram>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.cycleDuration);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.of(context).disableAnimations) {
      // Reduce motion: settle on the first node instead of looping forever.
      _controller.value = (0.5) / widget.steps.length;
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
    final n = widget.steps.length;
    // Below this width the horizontal row doesn't have enough room per node
    // (especially for the 6-step farmer journey) to show a title + subtitle
    // without wrapping awkwardly, so fall back to the stacked layout.
    final isNarrow = MediaQuery.of(context).size.width < 860;

    return isNarrow
        ? _VerticalFlow(steps: widget.steps, controller: _controller)
        : LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              const nodeSize = 64.0;
              final lineY = nodeSize / 2;

              return SizedBox(
                height: 216,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, _) {
                          return CustomPaint(
                            size: Size(width, nodeSize),
                            painter: _FlowLinePainter(
                              progress: _controller.value,
                              nodeCount: n,
                              lineY: lineY,
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Row(
                        children: [
                          for (int i = 0; i < n; i++)
                            Expanded(
                              child: _FlowNode(
                                step: widget.steps[i],
                                centerFraction: (i + 0.5) / n,
                                controller: _controller,
                                nodeSize: nodeSize,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }
}

/// Bump function: 1.0 right at [center], fading to 0 by [halfWidth] away,
/// wrapping around the 0..1 loop so the pulse highlights nodes near either
/// edge correctly.
double _proximity(double value, double center, double halfWidth) {
  double d = (value - center).abs();
  d = d > 0.5 ? 1.0 - d : d; // wrap-around distance on a 0..1 loop
  return (1 - d / halfWidth).clamp(0.0, 1.0);
}

class _FlowLinePainter extends CustomPainter {
  final double progress;
  final int nodeCount;
  final double lineY;

  _FlowLinePainter({required this.progress, required this.nodeCount, required this.lineY});

  @override
  void paint(Canvas canvas, Size size) {
    final trackPaint = Paint()
      ..color = Palette.paleGreen
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(size.width * 0.5 / nodeCount, lineY),
        Offset(size.width * (nodeCount - 0.5) / nodeCount, lineY), trackPaint);

    final pulseX = size.width * progress;
    final glowPaint = Paint()
      ..color = Palette.gold.withValues(alpha: 0.28)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(Offset(pulseX, lineY), 12, glowPaint);

    final dotPaint = Paint()..color = Palette.gold;
    canvas.drawCircle(Offset(pulseX, lineY), 6, dotPaint);
    canvas.drawCircle(
      Offset(pulseX, lineY),
      6,
      Paint()
        ..color = Palette.deepGreen
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );
  }

  @override
  bool shouldRepaint(covariant _FlowLinePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _FlowNode extends StatelessWidget {
  final ProcessStep step;
  final double centerFraction;
  final AnimationController controller;
  final double nodeSize;

  const _FlowNode({
    required this.step,
    required this.centerFraction,
    required this.controller,
    required this.nodeSize,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final intensity = _proximity(controller.value, centerFraction, 1 / 7);
        final scale = 1.0 + 0.18 * intensity;
        final bg = Color.lerp(Palette.paleGreen, Palette.deepGreen, intensity)!;
        final iconColor = Color.lerp(Palette.deepGreen, Colors.white, intensity)!;
        final titleColor = Color.lerp(Palette.ink, Palette.deepGreen, intensity)!;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.scale(
              scale: scale,
              child: Container(
                width: nodeSize,
                height: nodeSize,
                decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
                child: Icon(step.icon, color: iconColor),
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                step.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  height: 1.15,
                  color: titleColor,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                step.subtitle,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Palette.muted, fontSize: 12, height: 1.3),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Mobile fallback: same pulse concept, laid out as a vertical timeline
/// instead of a horizontal row (avoids cramming 4 nodes into a narrow width).
///
/// Each row has a fixed height so a single vertical line + travelling pulse
/// can be painted precisely down the left edge — this is what makes the
/// "loop" visibly work on phones, matching the horizontal desktop version,
/// instead of just showing static circles that pulse in place.
class _VerticalFlow extends StatelessWidget {
  final List<ProcessStep> steps;
  final AnimationController controller;

  static const double _rowHeight = 108;
  static const double _nodeSize = 48;

  const _VerticalFlow({required this.steps, required this.controller});

  @override
  Widget build(BuildContext context) {
    final n = steps.length;
    final totalHeight = _rowHeight * n;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: _nodeSize,
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                return CustomPaint(
                  size: Size(_nodeSize, totalHeight),
                  painter: _VerticalLinePainter(
                    progress: controller.value,
                    nodeCount: n,
                    rowHeight: _rowHeight,
                    nodeSize: _nodeSize,
                  ),
                );
              },
            ),
          ),
          Column(
            children: [
              for (int i = 0; i < n; i++)
                SizedBox(
                  height: _rowHeight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedBuilder(
                        animation: controller,
                        builder: (context, _) {
                          final intensity =
                              _proximity(controller.value, (i + 0.5) / n, 1 / 7);
                          final bg =
                              Color.lerp(Palette.paleGreen, Palette.deepGreen, intensity)!;
                          final iconColor =
                              Color.lerp(Palette.deepGreen, Colors.white, intensity)!;
                          return Container(
                            width: _nodeSize,
                            height: _nodeSize,
                            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
                            child: Icon(steps[i].icon, color: iconColor, size: 22),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                steps[i].title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 15),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                steps[i].subtitle,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Palette.muted, fontSize: 13, height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Paints the vertical track + a travelling glowing pulse down the column of
/// nodes, mirroring [_FlowLinePainter] but oriented for the mobile timeline.
class _VerticalLinePainter extends CustomPainter {
  final double progress;
  final int nodeCount;
  final double rowHeight;
  final double nodeSize;

  _VerticalLinePainter({
    required this.progress,
    required this.nodeCount,
    required this.rowHeight,
    required this.nodeSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final x = nodeSize / 2;
    final topY = rowHeight / 2;
    final bottomY = size.height - rowHeight / 2;

    final trackPaint = Paint()
      ..color = Palette.paleGreen
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(x, topY), Offset(x, bottomY), trackPaint);

    final pulseY = topY + (bottomY - topY) * progress;
    final glowPaint = Paint()
      ..color = Palette.gold.withValues(alpha: 0.28)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(Offset(x, pulseY), 12, glowPaint);

    final dotPaint = Paint()..color = Palette.gold;
    canvas.drawCircle(Offset(x, pulseY), 6, dotPaint);
    canvas.drawCircle(
      Offset(x, pulseY),
      6,
      Paint()
        ..color = Palette.deepGreen
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );
  }

  @override
  bool shouldRepaint(covariant _VerticalLinePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
