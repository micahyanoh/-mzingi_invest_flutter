import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'animated_logo.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onInvestNow;

  const NavBar({
    super.key,
    required this.currentIndex,
    required this.onSelect,
    required this.onInvestNow,
  });

  static const tabs = ['Home', 'Browse Farms', 'Portfolio'];

  @override
  Size get preferredSize => const Size.fromHeight(76);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 760;
    // Below this, even the logo + menu + compact button need every pixel,
    // so the brand wordmark is dropped rather than left to overflow.
    final showWordmark = width > 400;

    return Container(
      color: Palette.navGreen,
      padding: EdgeInsets.symmetric(horizontal: isWide ? 24 : 14),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            const AnimatedLogoMark(size: 34),
            if (showWordmark) ...[
              const SizedBox(width: 10),
              const Flexible(
                child: Text(
                  'M-Zingi Invest',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
            const Spacer(),
            if (isWide) ...[
              for (int i = 0; i < tabs.length; i++)
                _NavTab(
                  label: tabs[i],
                  selected: currentIndex == i,
                  onTap: () => onSelect(i),
                ),
              const SizedBox(width: 12),
            ] else
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                tooltip: 'Menu',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            SizedBox(width: isWide ? 0 : 8),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: isWide
                      ? null
                      : ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                          ),
                        ),
                  onPressed: onInvestNow,
                  child: Text(isWide ? 'Sign Up — Invest KES 100' : 'Invest KES 100'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: InkWell(
        onTap: onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            color: selected ? Palette.gold : Colors.white70,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 14.5,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 26),
                child: Text(label),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: selected ? 18 : 0,
                color: Palette.gold,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
