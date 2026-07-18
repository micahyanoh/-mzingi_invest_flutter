import 'package:flutter/material.dart';
import '../data/mock_farms.dart';
import '../models/farm.dart';
import '../theme/app_theme.dart';
import '../widgets/farm_card.dart';

class BrowseFarmsScreen extends StatefulWidget {
  final void Function(Farm) onOpenFarm;
  const BrowseFarmsScreen({super.key, required this.onOpenFarm});

  @override
  State<BrowseFarmsScreen> createState() => _BrowseFarmsScreenState();
}

class _BrowseFarmsScreenState extends State<BrowseFarmsScreen> {
  CropType? _filter;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 900;
    final columns = isWide ? 3 : (width > 600 ? 2 : 1);

    final crops = mockFarms.map((f) => f.crop).toSet().toList();
    final visible = _filter == null
        ? mockFarms
        : mockFarms.where((f) => f.crop == _filter).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 80 : 20, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Eyebrow('Browse Farms', color: Palette.deepGreen),
          const SizedBox(height: 8),
          Text('Every Listing, Verified First',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 20),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _FilterChip(
                  label: 'All',
                  selected: _filter == null,
                  onTap: () => setState(() => _filter = null),
                ),
                for (final crop in crops)
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: _FilterChip(
                      label: crop.label,
                      selected: _filter == crop,
                      onTap: () => setState(() => _filter = crop),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            child: GridView.builder(
              key: ValueKey(_filter),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: visible.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                // Taller cards give room for the photo, verification/carbon
                // badges, and product-reward tag without overflowing.
                childAspectRatio: isWide ? 0.82 : (columns == 2 ? 0.68 : 0.74),
              ),
              itemBuilder: (context, i) {
                return FarmCard(
                  farm: visible[i],
                  imageHeight: isWide ? 140 : 110,
                  revealDelay: Duration(milliseconds: 80 * i),
                  onTap: () => widget.onOpenFarm(visible[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? Palette.deepGreen : Palette.paleGreen,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Palette.deepGreen,
            fontWeight: FontWeight.w600,
            fontSize: 13.5,
          ),
        ),
      ),
    );
  }
}
