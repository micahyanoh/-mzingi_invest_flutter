import 'package:flutter/material.dart';
import '../models/farm.dart';
import '../theme/app_theme.dart';
import 'animated_progress_bar.dart';
import 'count_up.dart';

class FarmCard extends StatefulWidget {
  final Farm farm;
  final VoidCallback onTap;
  final Duration revealDelay;
  final double imageHeight;

  const FarmCard({
    super.key,
    required this.farm,
    required this.onTap,
    this.revealDelay = Duration.zero,
    this.imageHeight = 140,
  });

  @override
  State<FarmCard> createState() => _FarmCardState();
}

class _FarmCardState extends State<FarmCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final farm = widget.farm;
    final pct = (farm.fundedFraction * 100).round();

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _hovering ? -6 : 0, 0),
          decoration: BoxDecoration(
            color: Palette.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Palette.ink.withValues(alpha: _hovering ? 0.14 : 0.06),
                blurRadius: _hovering ? 24 : 12,
                offset: Offset(0, _hovering ? 12 : 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'farm-image-${farm.id}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: _FarmImage(
                    farm: farm,
                    height: widget.imageHeight,
                    hovering: _hovering,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      farm.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${farm.location} · ${farm.crop.label}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 13),
                    ),
                    if (farm.supportsProductReward) ...[
                      const SizedBox(height: 8),
                      _ProductRewardTag(crop: farm.crop),
                    ],
                    const SizedBox(height: 14),
                    AnimatedProgressBar(
                      fraction: farm.fundedFraction,
                      delay: widget.revealDelay,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Target: ${farm.formattedTarget} · ${farm.weeks} wks',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Palette.muted,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        CountUpText(
                          '$pct% funded',
                          delay: widget.revealDelay,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: Palette.deepGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Farm photo with a graceful fade-in once loaded, a subtle hover zoom, and
/// a fallback to the crop's brand colour if the image can't load (e.g. no
/// network access) so the layout never breaks.
class _FarmImage extends StatelessWidget {
  final Farm farm;
  final double height;
  final bool hovering;

  const _FarmImage({required this.farm, required this.height, required this.hovering});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: height,
          width: double.infinity,
          child: farm.imageUrl.isEmpty
              ? Container(color: farm.crop.swatch)
              : AnimatedScale(
                  scale: hovering ? 1.06 : 1.0,
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOut,
                  child: Image.network(
                    farm.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: height,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) {
                        return AnimatedOpacity(
                          opacity: 1,
                          duration: const Duration(milliseconds: 320),
                          child: child,
                        );
                      }
                      return _ShimmerPlaceholder(color: farm.crop.swatch);
                    },
                    errorBuilder: (context, error, stack) =>
                        Container(color: farm.crop.swatch),
                  ),
                ),
        ),
        Positioned(
          left: 12,
          bottom: 12,
          child: _VerifiedChip(),
        ),
        if (farm.carbonCreditEligible)
          Positioned(
            right: 12,
            top: 12,
            child: _CarbonChip(),
          ),
      ],
    );
  }
}

/// A soft, looping shimmer sweep shown while the network image loads.
class _ShimmerPlaceholder extends StatefulWidget {
  final Color color;
  const _ShimmerPlaceholder({required this.color});

  @override
  State<_ShimmerPlaceholder> createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<_ShimmerPlaceholder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
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
        return Container(
          color: widget.color,
          child: FractionallySizedBox(
            alignment: Alignment(-1 + 2 * _controller.value, 0),
            widthFactor: 0.5,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0),
                    Colors.white.withValues(alpha: 0.35),
                    Colors.white.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _VerifiedChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Palette.navGreen.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified, size: 13, color: Palette.gold),
          SizedBox(width: 5),
          Text(
            'IoT verified',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CarbonChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.eco, size: 13, color: Palette.deepGreen),
          SizedBox(width: 4),
          Text(
            'Carbon credit',
            style: TextStyle(
              color: Palette.deepGreen,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductRewardTag extends StatelessWidget {
  final CropType crop;
  const _ProductRewardTag({required this.crop});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Palette.tan,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Palette.gold.withValues(alpha: 0.6), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inventory_2, size: 12, color: Palette.deepGreen),
          const SizedBox(width: 5),
          Text(
            crop == CropType.honey ? 'Get paid in honey' : 'Product reward available',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Palette.deepGreen,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
