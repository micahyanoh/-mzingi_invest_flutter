import 'package:flutter/material.dart';
import '../data/mock_farms.dart';
import '../models/farm.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_logo.dart';
import '../widgets/corporate_carbon_section.dart';
import '../widgets/count_up.dart';
import '../widgets/farm_card.dart';
import '../widgets/farmer_journey.dart';
import '../widgets/faq_accordion.dart';
import '../widgets/join_waitlist_dialog.dart';
import '../widgets/origin_story.dart';
import '../widgets/process_flow.dart';
import '../widgets/reveal.dart';
import '../widgets/trust_section.dart';
import '../widgets/waitlist_section.dart';

class LandingScreen extends StatefulWidget {
  final void Function(Farm) onOpenFarm;
  final VoidCallback onBrowseAll;
  final VoidCallback onInvestNow;

  const LandingScreen({
    super.key,
    required this.onOpenFarm,
    required this.onBrowseAll,
    required this.onInvestNow,
  });

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    super.initState();
    // Pop the "Join the Waitlist" dialog open every time this page loads,
    // in addition to the always-visible WaitlistSection form further down
    // the page. Scheduled for the end of the first frame so `context` has
    // a Navigator/Overlay to show the dialog on.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) JoinWaitlistDialog.show(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 900;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Hero(isWide: isWide, onBrowseAll: widget.onBrowseAll, onInvestNow: widget.onInvestNow),
          _StatsStrip(isWide: isWide),
          _HowItWorks(isWide: isWide),
          FarmerJourneySection(isWide: isWide),
          TrustSection(isWide: isWide),
          OriginStorySection(isWide: isWide),
          _FeaturedFarms(isWide: isWide, onOpenFarm: widget.onOpenFarm, onBrowseAll: widget.onBrowseAll),
          CorporateCarbonSection(isWide: isWide),
          WaitlistSection(isWide: isWide),
          FaqSection(isWide: isWide),
          const _Footer(),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final bool isWide;
  final VoidCallback onBrowseAll;
  final VoidCallback onInvestNow;

  const _Hero({
    required this.isWide,
    required this.onBrowseAll,
    required this.onInvestNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Palette.deepGreen,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: isWide ? 96 : 56,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const AnimatedLogoMark(size: 72),
          const SizedBox(height: 28),
          Reveal(
            delay: const Duration(milliseconds: 150),
            child: Text(
              'Grow your money\nin Kenyan soil.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    fontSize: isWide ? 56 : 36,
                  ),
            ),
          ),
          const SizedBox(height: 20),
          Reveal(
            delay: const Duration(milliseconds: 280),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Text(
                'Back verified smallholder farms from KES 100. Track every '
                'harvest. Get paid via M-Pesa.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.white70, fontSize: 17),
              ),
            ),
          ),
          const SizedBox(height: 34),
          Reveal(
            delay: const Duration(milliseconds: 400),
            child: Wrap(
              spacing: 16,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: onInvestNow,
                  child: const Text('Start Investing →'),
                ),
                OutlinedButton(
                  onPressed: onBrowseAll,
                  child: const Text('Browse Farms'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 44),
          Reveal(
            delay: const Duration(milliseconds: 520),
            child: _MiniFactRow(isWide: isWide),
          ),
        ],
      ),
    );
  }
}

class _MiniFactRow extends StatelessWidget {
  final bool isWide;
  const _MiniFactRow({required this.isWide});

  static bool _isNumeric(String s) => RegExp(r'\d').hasMatch(s);

  @override
  Widget build(BuildContext context) {
    final facts = const [
      ('KES 100', 'MIN. ENTRY'),
      ('48 hrs', 'PAYOUT SPEED'),
      ('M-Pesa', 'POWERED'),
    ];
    return Wrap(
      spacing: isWide ? 0 : 20,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: [
        for (int i = 0; i < facts.length; i++)
          Container(
            padding: EdgeInsets.symmetric(horizontal: isWide ? 28 : 0, vertical: 4),
            decoration: (i == 0 || !isWide)
                ? null
                : const BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.white24, width: 1),
                    ),
                  ),
            child: Column(
              children: [
                _isNumeric(facts[i].$1)
                    ? CountUpText(
                        facts[i].$1,
                        loop: true,
                        delay: Duration(milliseconds: 200 * i),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      )
                    : Text(
                        facts[i].$1,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                const SizedBox(height: 4),
                Text(
                  facts[i].$2,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _StatsStrip extends StatelessWidget {
  final bool isWide;
  const _StatsStrip({required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.cream,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: isWide ? 64 : 40,
      ),
      child: Wrap(
        spacing: 40,
        runSpacing: 28,
        alignment: WrapAlignment.center,
        children: [
          for (int i = 0; i < impactStats.length; i++)
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 220),
              child: Column(
                children: [
                  CountUpText(
                    impactStats[i].value,
                    delay: Duration(milliseconds: 150 * i),
                    loop: true,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Palette.deepGreen,
                          fontSize: 34,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    impactStats[i].label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Palette.muted, fontSize: 13),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _HowItWorks extends StatelessWidget {
  final bool isWide;
  const _HowItWorks({required this.isWide});

  @override
  Widget build(BuildContext context) {
    const steps = [
      ProcessStep(
        icon: Icons.travel_explore,
        title: 'Browse & Invest',
        subtitle: 'Pick a verified listing from KES 100.',
      ),
      ProcessStep(
        icon: Icons.lock_clock,
        title: 'Capital Released',
        subtitle: 'Funds sit in escrow, released in milestones.',
      ),
      ProcessStep(
        icon: Icons.sensors,
        title: 'Follow the Farm',
        subtitle: 'IoT data and photo updates, in real time.',
      ),
      ProcessStep(
        icon: Icons.payments,
        title: 'Return Paid',
        subtitle: 'Harvest sells, you get paid via M-Pesa.',
      ),
    ];

    return Container(
      color: Palette.white,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: isWide ? 72 : 48,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Eyebrow('How It Works', color: Palette.deepGreen),
          const SizedBox(height: 10),
          Text('Watch the Loop Work',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          const Text(
            "Money doesn't just move once — it cycles. Here's the loop, live.",
            style: TextStyle(color: Palette.muted, fontSize: 14.5),
          ),
          const SizedBox(height: 44),
          const Reveal(child: ProcessFlowDiagram(steps: steps)),
        ],
      ),
    );
  }
}

class _FeaturedFarms extends StatelessWidget {
  final bool isWide;
  final void Function(Farm) onOpenFarm;
  final VoidCallback onBrowseAll;

  const _FeaturedFarms({
    required this.isWide,
    required this.onOpenFarm,
    required this.onBrowseAll,
  });

  @override
  Widget build(BuildContext context) {
    final featured = mockFarms.take(3).toList();
    final columns = isWide ? 3 : 1;

    return Container(
      color: Palette.cream,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: isWide ? 72 : 48,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'Featured Farms Open for Investment',
                  style: isWide
                      ? Theme.of(context).textTheme.headlineMedium
                      : Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: onBrowseAll,
                child: const Text('View all →'),
              ),
            ],
          ),
          const SizedBox(height: 28),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: featured.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              // Narrower than the old 1.15 so the image + badges + text
              // have room to breathe on mobile without overflowing.
              childAspectRatio: isWide ? 0.82 : 0.74,
            ),
            itemBuilder: (context, i) {
              return FarmCard(
                farm: featured[i],
                imageHeight: isWide ? 140 : 120,
                revealDelay: Duration(milliseconds: 120 * i),
                onTap: () => onOpenFarm(featured[i]),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.navGreen,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: const Column(
        children: [
          Text(
            'M-Zingi Invest',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Empower farmers. Grow your wealth. Transform Kenya.',
            style: TextStyle(color: Colors.white54, fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}
