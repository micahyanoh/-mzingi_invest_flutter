import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnimatedProgressBar extends StatefulWidget {
  final double fraction; // 0..1
  final Duration delay;
  final double height;
  final Color trackColor;
  final Color fillColor;

  const AnimatedProgressBar({
    super.key,
    required this.fraction,
    this.delay = Duration.zero,
    this.height = 8,
    this.trackColor = Palette.paleGreen,
    this.fillColor = Palette.deepGreen,
  });

  @override
  State<AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _anim = Tween<double>(begin: 0, end: widget.fraction).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    Future.delayed(widget.delay, () {
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
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              height: widget.height,
              width: double.infinity,
              decoration: BoxDecoration(
                color: widget.trackColor,
                borderRadius: BorderRadius.circular(widget.height),
              ),
            ),
            if (reduceMotion)
              Container(
                height: widget.height,
                width: constraints.maxWidth * widget.fraction,
                decoration: BoxDecoration(
                  color: widget.fillColor,
                  borderRadius: BorderRadius.circular(widget.height),
                ),
              )
            else
              AnimatedBuilder(
                animation: _anim,
                builder: (context, _) {
                  return Container(
                    height: widget.height,
                    width: constraints.maxWidth * _anim.value,
                    decoration: BoxDecoration(
                      color: widget.fillColor,
                      borderRadius: BorderRadius.circular(widget.height),
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
