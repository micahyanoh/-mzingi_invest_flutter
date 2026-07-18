import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'reveal.dart';

class TrustSection extends StatelessWidget {
  final bool isWide;
  const TrustSection({super.key, required this.isWide});

  @override
  Widget build(BuildContext context) {
    final items = const [
      (
        Icons.sensors_outlined,
        'IoT Sensors',
        'Soil moisture, weather and growth data logged automatically — no one has to take our word for it.',
      ),
      (
        Icons.fact_check_outlined,
        'Field Verification',
        'Every listing is visited and checked before it goes live: land, documents, and the plot itself.',
      ),
      (
        Icons.dashboard_outlined,
        'Live Dashboards',
        'Photo and data updates as the farm progresses — you watch the season happen, not just the payout.',
      ),
      (
        Icons.shield_outlined,
        'Escrow Protected',
        "Capital sits in escrow and releases in milestones, never as one lump sum to the farmer.",
      ),
    ];

    return Container(
      color: Palette.navGreen,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: isWide ? 72 : 48,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Eyebrow('Verified, Not Visited'),
          const SizedBox(height: 10),
          Text(
            'Trust Built on Data, Not Distance',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              "You never need to meet a farmer to trust the farm. We replace "
              "relationship-based trust with data you can check yourself.",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 14.5, height: 1.5),
            ),
          ),
          const SizedBox(height: 44),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              for (int i = 0; i < items.length; i++)
                Reveal(
                  delay: Duration(milliseconds: 110 * i),
                  child: SizedBox(
                    width: 240,
                    child: Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                            border: Border.all(color: Palette.gold, width: 1.2),
                          ),
                          child: Icon(items[i].$1, color: Palette.gold),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          items[i].$2,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          items[i].$3,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
