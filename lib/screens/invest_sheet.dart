import 'package:flutter/material.dart';
import '../models/farm.dart';
import '../theme/app_theme.dart';
import '../widgets/count_up.dart';

Future<void> showInvestSheet(BuildContext context, Farm farm) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _InvestSheet(farm: farm),
  );
}

class _InvestSheet extends StatefulWidget {
  final Farm farm;
  const _InvestSheet({required this.farm});

  @override
  State<_InvestSheet> createState() => _InvestSheetState();
}

class _InvestSheetState extends State<_InvestSheet> {
  int _amount = 500;
  bool _confirmed = false;
  bool _submitting = false;
  late RewardType _rewardType;

  static const _quickAmounts = [100, 500, 1000, 5000];

  @override
  void initState() {
    super.initState();
    _rewardType = RewardType.cashPayout;
  }

  void _submit() async {
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _confirmed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Palette.cream,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
          child: _confirmed ? _buildSuccess(context) : _buildForm(context),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      key: const ValueKey('form'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Palette.paleGreen,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        Text('Invest in ${widget.farm.name}',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        const Text(
          'Funds are held in escrow until milestones are confirmed.',
          style: TextStyle(color: Palette.muted, fontSize: 13),
        ),
        const SizedBox(height: 22),
        const Text('Amount (KES)',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: [
            for (final amt in _quickAmounts)
              ChoiceChip(
                label: Text('KES $amt'),
                selected: _amount == amt,
                onSelected: (_) => setState(() => _amount = amt),
                selectedColor: Palette.deepGreen,
                labelStyle: TextStyle(
                  color: _amount == amt ? Colors.white : Palette.ink,
                  fontWeight: FontWeight.w600,
                ),
                backgroundColor: Palette.paleGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide.none,
                ),
              ),
          ],
        ),
        if (widget.farm.supportsProductReward) ...[
          const SizedBox(height: 22),
          const Text('How do you want your return?',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          const SizedBox(height: 10),
          Row(
            children: [
              for (final type in RewardType.values)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: type == RewardType.values.first ? 10 : 0,
                    ),
                    child: _RewardTypeOption(
                      type: type,
                      selected: _rewardType == type,
                      onTap: () => setState(() => _rewardType = type),
                    ),
                  ),
                ),
            ],
          ),
          if (_rewardType == RewardType.physicalProduct &&
              widget.farm.productRewardDescription != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Palette.paleGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                widget.farm.productRewardDescription!,
                style: const TextStyle(
                  color: Palette.deepGreen,
                  fontSize: 12.5,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ],
        const SizedBox(height: 26),
        Row(
          children: [
            const Icon(Icons.phone_iphone, size: 18, color: Palette.deepGreen),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                "You'll confirm this amount via an M-Pesa STK push.",
                style: TextStyle(fontSize: 12.5, color: Palette.muted),
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor: AlwaysStoppedAnimation(Palette.ink),
                    ),
                  )
                : CountUpText(
                    'Confirm KES $_amount',
                    duration: const Duration(milliseconds: 450),
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccess(BuildContext context) {
    return Column(
      key: const ValueKey('success'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        const _AnimatedCheck(),
        const SizedBox(height: 20),
        Text('Investment confirmed', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          'KES $_amount is now in escrow for ${widget.farm.name}. '
          "You'll get updates as milestones are verified, and "
          '${_rewardType == RewardType.physicalProduct ? "your product reward will be delivered" : "your payout will land via M-Pesa"} '
          'once the harvest sells.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Palette.muted, fontSize: 13.5, height: 1.5),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Palette.deepGreen,
              side: const BorderSide(color: Palette.deepGreen),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ),
      ],
    );
  }
}

/// A tappable card for choosing between a cash payout or an actual physical
/// product (e.g. jars of honey, bags of coffee) as the investment reward.
class _RewardTypeOption extends StatelessWidget {
  final RewardType type;
  final bool selected;
  final VoidCallback onTap;

  const _RewardTypeOption({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Palette.deepGreen : Palette.paleGreen,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? Palette.deepGreen : Colors.transparent,
            width: 1.4,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              type.icon,
              size: 20,
              color: selected ? Colors.white : Palette.deepGreen,
            ),
            const SizedBox(height: 6),
            Text(
              type.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : Palette.deepGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A small hand-drawn checkmark that strokes itself on — the "payment
/// confirmed" motion moment.
class _AnimatedCheck extends StatefulWidget {
  const _AnimatedCheck();

  @override
  State<_AnimatedCheck> createState() => _AnimatedCheckState();
}

class _AnimatedCheckState extends State<_AnimatedCheck>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
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
          size: const Size(84, 84),
          painter: _CheckPainter(progress: Curves.easeOutCubic.transform(_controller.value)),
        );
      },
    );
  }
}

class _CheckPainter extends CustomPainter {
  final double progress; // 0..1
  _CheckPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final circlePaint = Paint()
      ..color = Palette.deepGreen.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, circlePaint);

    final ringPaint = Paint()
      ..color = Palette.deepGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 4),
      -1.5708,
      6.2832 * progress.clamp(0, 1),
      false,
      ringPaint,
    );

    // Checkmark drawn as two segments, appearing after the ring is ~70% done
    final checkT = ((progress - 0.55) / 0.45).clamp(0.0, 1.0);
    if (checkT > 0) {
      final p1 = Offset(size.width * 0.30, size.height * 0.52);
      final p2 = Offset(size.width * 0.44, size.height * 0.66);
      final p3 = Offset(size.width * 0.72, size.height * 0.36);

      final checkPaint = Paint()
        ..color = Palette.deepGreen
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final path = Path()..moveTo(p1.dx, p1.dy);
      if (checkT <= 0.5) {
        final t = checkT / 0.5;
        path.lineTo(
          p1.dx + (p2.dx - p1.dx) * t,
          p1.dy + (p2.dy - p1.dy) * t,
        );
      } else {
        path.lineTo(p2.dx, p2.dy);
        final t = (checkT - 0.5) / 0.5;
        path.lineTo(
          p2.dx + (p3.dx - p2.dx) * t,
          p2.dy + (p3.dy - p2.dy) * t,
        );
      }
      canvas.drawPath(path, checkPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CheckPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
