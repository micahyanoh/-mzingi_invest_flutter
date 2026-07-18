import 'package:flutter/material.dart';

/// Wraps [child] in a one-shot fade + slide-up entrance animation.
///
/// This is intentionally simple (delay-triggered, not scroll-triggered) so
/// the whole project stays dependency-free. If you want true scroll-linked
/// reveals later, swap this for the `visibility_detector` package and call
/// `_play()` from its callback instead of `initState`.
class Reveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double offsetY;

  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 620),
    this.offsetY = 24,
  });

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: Offset(0, widget.offsetY / 100),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

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
    if (MediaQuery.of(context).disableAnimations) {
      // Respect system-level "reduce motion": show the end state immediately,
      // no fade or slide.
      return widget.child;
    }
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

/// Staggers [children] through [Reveal], spacing each start by [stagger].
class StaggeredReveal extends StatelessWidget {
  final List<Widget> children;
  final Duration stagger;
  final Duration initialDelay;
  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const StaggeredReveal({
    super.key,
    required this.children,
    this.stagger = const Duration(milliseconds: 90),
    this.initialDelay = Duration.zero,
    this.direction = Axis.vertical,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final wrapped = <Widget>[
      for (int i = 0; i < children.length; i++)
        Reveal(
          delay: initialDelay + stagger * i,
          child: children[i],
        ),
    ];

    return direction == Axis.vertical
        ? Column(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: wrapped,
          )
        : Row(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: wrapped,
          );
  }
}
