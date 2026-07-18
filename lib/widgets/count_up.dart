import 'package:flutter/material.dart';

/// Animates from 0 up to the numeric portion of [target], keeping any
/// non-numeric prefix/suffix (e.g. "$", "%", "+", "M") intact.
///
/// Two modes:
/// - One-shot (default): counts up once on mount, and smoothly re-counts
///   from the old value to a new one if [target] changes later (e.g. when
///   a user taps a different investment amount).
/// - Looping ([loop] = true): keeps counting up, holds briefly at the
///   target, then resets and counts up again — forever. This is for
///   ambient stat displays that should always feel "alive" rather than
///   settle into static text, echoing the app's own "keep the loop
///   going" theme.
///
/// Examples handled: "33%", "4M+", "\$200B", "KES 180,000" (commas kept).
class CountUpText extends StatefulWidget {
  final String target;
  final TextStyle? style;
  final Duration delay;
  final Duration duration;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool loop;
  final Duration holdDuration;

  const CountUpText(
    this.target, {
    super.key,
    this.style,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 1100),
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.loop = false,
    this.holdDuration = const Duration(milliseconds: 2400),
  });

  @override
  State<CountUpText> createState() => _CountUpTextState();
}

class _ParsedTarget {
  final String prefix;
  final int number;
  final String suffix;
  final bool grouped; // whether the original number used thousands commas
  const _ParsedTarget(this.prefix, this.number, this.suffix, this.grouped);
}

_ParsedTarget _parse(String raw) {
  final match = RegExp(r'^(\D*)([\d,]+)(.*)$').firstMatch(raw);
  if (match == null) return _ParsedTarget('', 0, raw, false);
  final digits = match.group(2) ?? '0';
  return _ParsedTarget(
    match.group(1) ?? '',
    int.tryParse(digits.replaceAll(',', '')) ?? 0,
    match.group(3) ?? '',
    digits.contains(','),
  );
}

/// Formats [n] with thousands separators, e.g. 180000 -> "180,000".
String _formatGrouped(int n) {
  final s = n.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    final posFromEnd = s.length - i;
    buf.write(s[i]);
    if (posFromEnd > 1 && posFromEnd % 3 == 1) buf.write(',');
  }
  return buf.toString();
}

class _CountUpTextState extends State<CountUpText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<int> _value;
  late _ParsedTarget _parsed;
  bool _disposed = false;
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    _parsed = _parse(widget.target);
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _value = IntTween(begin: 0, end: _parsed.number).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    if (widget.loop) {
      _controller.addStatusListener(_onStatus);
    }

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  void _onStatus(AnimationStatus status) async {
    if (status != AnimationStatus.completed) return;
    if (_reduceMotion) return;
    await Future.delayed(widget.holdDuration);
    if (_disposed || !mounted) return;
    // Loop back to zero and count up again, indefinitely.
    _value = IntTween(begin: 0, end: _parsed.number).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller
      ..reset()
      ..forward();
  }

  @override
  void didUpdateWidget(covariant CountUpText oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newParsed = _parse(widget.target);
    final unchanged = newParsed.number == _parsed.number &&
        newParsed.prefix == _parsed.prefix &&
        newParsed.suffix == _parsed.suffix;
    if (unchanged) return;

    _parsed = newParsed;
    if (widget.loop) {
      // Let the current/next natural loop cycle pick up the new target
      // rather than yanking the controller mid-cycle.
      return;
    }

    // Re-count from wherever the animation currently sits to the new value,
    // rather than jumping straight to it — this is what makes tapping a new
    // investment amount feel like it's ticking, not just swapping text.
    final start = _value.value;
    _value = IntTween(begin: start, end: newParsed.number).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller
      ..stop()
      ..reset()
      ..forward();
  }

  @override
  void dispose() {
    _disposed = true;
    _controller.dispose();
    super.dispose();
  }

  String _label(int value) {
    final formatted = _parsed.grouped ? _formatGrouped(value) : '$value';
    return '${_parsed.prefix}$formatted${_parsed.suffix}';
  }

  @override
  Widget build(BuildContext context) {
    _reduceMotion = MediaQuery.of(context).disableAnimations;
    if (_reduceMotion) {
      return Text(
        _label(_parsed.number),
        style: widget.style,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        overflow: widget.overflow,
      );
    }
    return AnimatedBuilder(
      animation: _value,
      builder: (context, _) {
        return Text(
          _label(_value.value),
          style: widget.style,
          textAlign: widget.textAlign,
          maxLines: widget.maxLines,
          overflow: widget.overflow,
        );
      },
    );
  }
}
