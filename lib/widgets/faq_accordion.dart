import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'reveal.dart';

class FaqItemData {
  final String question;
  final String answer;
  const FaqItemData(this.question, this.answer);
}

const List<FaqItemData> faqItems = [
  FaqItemData(
    'What if the harvest fails?',
    'Short-cycle, diversified listings across fruits, vegetables and honey '
        'spread risk across many small harvests rather than one annual crop. '
        'Weather-index crop micro-insurance is being scoped for higher-risk listings.',
  ),
  FaqItemData(
    'How are farmers vetted?',
    'On-site verification, land documents and plot inspection happen before '
        'a listing goes live, filtered further by a small listing fee before '
        'any capital is deployed.',
  ),
  FaqItemData(
    'Is my money safe?',
    'Funds sit in escrow and release in milestone-linked tranches — never '
        'paid to the farmer outright.',
  ),
  FaqItemData(
    'Do I deal with farmers directly?',
    "No. M-Zingi Invest is the sole point of contact: you track listings "
        "through IoT data and updates, not personal relationships.",
  ),
  FaqItemData(
    'What returns can I expect?',
    'Returns vary by listing and cycle length. Short produce cycles let '
        'capital recycle several times a year instead of once.',
  ),
];

class FaqSection extends StatefulWidget {
  final bool isWide;
  const FaqSection({super.key, required this.isWide});

  @override
  State<FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends State<FaqSection> {
  int? _openIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.cream,
      padding: EdgeInsets.symmetric(
        horizontal: widget.isWide ? 80 : 24,
        vertical: widget.isWide ? 72 : 48,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Eyebrow('Questions', color: Palette.deepGreen),
          const SizedBox(height: 10),
          Text('Anticipated Questions, Answered',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 36),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              children: [
                for (int i = 0; i < faqItems.length; i++)
                  Reveal(
                    delay: Duration(milliseconds: 70 * i),
                    child: _FaqTile(
                      data: faqItems[i],
                      open: _openIndex == i,
                      onTap: () => setState(() {
                        _openIndex = _openIndex == i ? null : i;
                      }),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final FaqItemData data;
  final bool open;
  final VoidCallback onTap;

  const _FaqTile({required this.data, required this.open, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Palette.paleGreen, width: 1.2),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      data.question,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                  ),
                  AnimatedRotation(
                    turns: open ? 0.5 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: const Icon(Icons.keyboard_arrow_down, color: Palette.deepGreen),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 220),
            crossFadeState: open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  data.answer,
                  style: const TextStyle(color: Palette.muted, fontSize: 13.5, height: 1.55),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
