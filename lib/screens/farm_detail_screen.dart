import 'package:flutter/material.dart';
import '../models/farm.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_progress_bar.dart';
import '../widgets/count_up.dart';
import '../widgets/reveal.dart';
import 'invest_sheet.dart';

class FarmDetailScreen extends StatelessWidget {
  final Farm farm;
  const FarmDetailScreen({super.key, required this.farm});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    final pct = (farm.fundedFraction * 100).round();

    return Scaffold(
      backgroundColor: Palette.cream,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Palette.navGreen,
            pinned: true,
            expandedHeight: 260,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'farm-image-${farm.id}',
                child: farm.imageUrl.isEmpty
                    ? Container(color: farm.crop.swatch)
                    : Image.network(
                        farm.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(color: farm.crop.swatch);
                        },
                        errorBuilder: (context, error, stack) =>
                            Container(color: farm.crop.swatch),
                      ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 40 : 20,
                    vertical: 32,
                  ),
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: _Details(farm: farm)),
                            const SizedBox(width: 40),
                            Expanded(
                              flex: 2,
                              child: _InvestCard(farm: farm, pct: pct),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _Details(farm: farm),
                            const SizedBox(height: 28),
                            _InvestCard(farm: farm, pct: pct),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Details extends StatelessWidget {
  final Farm farm;
  const _Details({required this.farm});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Reveal(
          child: Text(
            farm.name,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 30),
          ),
        ),
        const SizedBox(height: 6),
        Reveal(
          delay: const Duration(milliseconds: 80),
          child: Text(
            '${farm.location} · ${farm.crop.label} · ${farm.weeks} week cycle',
            style: const TextStyle(color: Palette.muted, fontSize: 14.5),
          ),
        ),
        const SizedBox(height: 22),
        Reveal(
          delay: const Duration(milliseconds: 160),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              if (farm.iotVerified) const _Badge(Icons.sensors, 'IoT verified'),
              if (farm.fieldVerified)
                const _Badge(Icons.fact_check, 'Field verified'),
              const _Badge(Icons.lock, 'Escrow protected'),
              if (farm.supportsProductReward)
                const _Badge(Icons.inventory_2, 'Product reward available'),
              if (farm.carbonCreditEligible)
                const _Badge(Icons.eco, 'Carbon credit eligible'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Reveal(
          delay: const Duration(milliseconds: 220),
          child: Text(farm.summary,
              style: Theme.of(context).textTheme.bodyLarge),
        ),
        if (farm.supportsProductReward && farm.productRewardDescription != null) ...[
          const SizedBox(height: 20),
          Reveal(
            delay: const Duration(milliseconds: 250),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Palette.tan,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Palette.gold.withValues(alpha: 0.5)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.inventory_2, color: Palette.deepGreen),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Prefer the actual product? ${farm.productRewardDescription!}',
                      style: const TextStyle(
                          color: Palette.deepGreen, fontSize: 13.5, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 28),
        Reveal(
          delay: const Duration(milliseconds: 280),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Palette.paleGreen,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(Icons.timeline, color: Palette.deepGreen),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Milestone-linked tranches: capital releases in stages as '
                    'planting, growth and harvest checkpoints are confirmed '
                    'through field visits and IoT data — never as one lump sum.',
                    style: TextStyle(color: Palette.deepGreen, fontSize: 13.5, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Badge(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Palette.white,
        border: Border.all(color: Palette.paleGreen, width: 1.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Palette.deepGreen),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Palette.deepGreen,
              )),
        ],
      ),
    );
  }
}

class _InvestCard extends StatelessWidget {
  final Farm farm;
  final int pct;
  const _InvestCard({required this.farm, required this.pct});

  @override
  Widget build(BuildContext context) {
    return Reveal(
      delay: const Duration(milliseconds: 160),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Palette.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Palette.ink.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CountUpText(
                  farm.formattedTarget,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                ),
                CountUpText(
                  '$pct% funded',
                  style: const TextStyle(
                      color: Palette.deepGreen, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AnimatedProgressBar(fraction: farm.fundedFraction, height: 10),
            const SizedBox(height: 20),
            _StatRow(label: 'Cycle length', value: '${farm.weeks} weeks'),
            _StatRow(
                label: 'Illustrative return',
                value: '${farm.estReturnPct.toStringAsFixed(0)}%'),
            _StatRow(label: 'Minimum investment', value: 'KES 100'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => showInvestSheet(context, farm),
                child: const Text('Invest in this Farm'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Palette.muted, fontSize: 13.5)),
          CountUpText(
            value,
            duration: const Duration(milliseconds: 700),
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
          ),
        ],
      ),
    );
  }
}
