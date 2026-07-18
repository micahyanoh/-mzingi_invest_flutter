import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'process_flow.dart';
import 'reveal.dart';

/// The mirror image of "How It Works": the same looping diagram, but told
/// from the farmer's side of the cycle rather than the investor's.
class FarmerJourneySection extends StatelessWidget {
  final bool isWide;
  const FarmerJourneySection({super.key, required this.isWide});

  @override
  Widget build(BuildContext context) {
    const steps = [
      ProcessStep(
        icon: Icons.edit_document,
        title: 'List the Farm',
        subtitle: 'A farmer shares their operation and a co-investment need.',
      ),
      ProcessStep(
        icon: Icons.fact_check,
        title: 'Sign the Contract',
        subtitle: 'Both sides sign, setting the profit-split terms upfront.',
      ),
      ProcessStep(
        icon: Icons.handshake,
        title: 'We Co-Invest',
        subtitle: 'Capital sits alongside the farmer\'s own — we don\'t take '
            'over or interfere with how the farm already runs.',
      ),
      ProcessStep(
        icon: Icons.agriculture,
        title: 'Farming Continues as Usual',
        subtitle: 'The farmer keeps running things their way; we just watch '
            'the season unfold through light-touch updates.',
      ),
      ProcessStep(
        icon: Icons.storefront,
        title: 'Harvest & Sell',
        subtitle: 'The harvest sells through the farmer\'s own channels.',
      ),
      ProcessStep(
        icon: Icons.pie_chart,
        title: 'Split the Profits',
        subtitle: 'Proceeds are divided exactly as the contract states, '
            'then the cycle opens again next season.',
      ),
    ];

    return Container(
      color: Palette.paleGreen.withValues(alpha: 0.35),
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: isWide ? 72 : 48,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Eyebrow('For Farmers', color: Palette.deepGreen),
          const SizedBox(height: 10),
          Text('The Farmer\'s Journey',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: const Text(
              'We co-invest, we sign a contract, and we stay out of your '
              'way. No takeover, no interference with what you\'re already '
              'doing — we simply split the profits as agreed.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Palette.muted, fontSize: 14.5, height: 1.5),
            ),
          ),
          const SizedBox(height: 44),
          const Reveal(
            child: ProcessFlowDiagram(
              steps: steps,
              cycleDuration: Duration(seconds: 10),
            ),
          ),
          const SizedBox(height: 32),
          Reveal(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Palette.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Palette.deepGreen.withValues(alpha: 0.15)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.verified_user, color: Palette.deepGreen),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your farm stays yours. We don\'t touch your existing '
                        'investments or day-to-day decisions — our stake is '
                        'purely contractual, and profits are split exactly '
                        'as the agreement sets out.',
                        style: TextStyle(
                          color: Palette.deepGreen,
                          fontSize: 13.5,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
