import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'count_up.dart';
import 'reveal.dart';
import '../screens/corporate_carbon_sheet.dart';

/// Pitches bulk / corporate-scale participation: instead of buying into one
/// listing, a company funds a basket of carbon-sequestering listings
/// (agroforestry, beehives, tea) and earns verifiable carbon credits plus a
/// CSR/ESG story, on top of the usual financial return.
class CorporateCarbonSection extends StatelessWidget {
  final bool isWide;
  const CorporateCarbonSection({super.key, required this.isWide});

  @override
  Widget build(BuildContext context) {
    final stats = const [
      ('12', 'tCO₂e sequestered / year per hectare'),
      ('40+', 'agroforestry & beehive listings eligible'),
      ('100%', 'verified via field visits + IoT data'),
    ];

    return Container(
      width: double.infinity,
      color: Palette.deepGreen,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: isWide ? 80 : 52,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Eyebrow('For Corporates'),
          const SizedBox(height: 10),
          Text(
            'Carbon Credits, Grown Locally',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 14),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Text(
              'Corporates can fund a basket of agroforestry, tea and bee '
              'hive listings that sequester carbon and protect pollinator '
              'habitat — earning verifiable carbon credits and an ESG story '
              'alongside smallholder farmers, not instead of them.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 14.5, height: 1.6),
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 40,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              for (int i = 0; i < stats.length; i++)
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 220),
                  child: Column(
                    children: [
                      CountUpText(
                        stats[i].$1,
                        delay: Duration(milliseconds: 130 * i),
                        loop: true,
                        style: const TextStyle(
                          color: Palette.gold,
                          fontWeight: FontWeight.w800,
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        stats[i].$2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white60, fontSize: 12.5),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 40),
          Reveal(
            child: ElevatedButton.icon(
              onPressed: () => showCorporateCarbonSheet(context),
              icon: const Icon(Icons.eco),
              label: const Text('Request a Corporate Partnership'),
            ),
          ),
        ],
      ),
    );
  }
}
