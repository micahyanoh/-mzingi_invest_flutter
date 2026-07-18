import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

Future<void> showCorporateCarbonSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _CorporateCarbonSheet(),
  );
}

class _CorporateCarbonSheet extends StatefulWidget {
  const _CorporateCarbonSheet();

  @override
  State<_CorporateCarbonSheet> createState() => _CorporateCarbonSheetState();
}

class _CorporateCarbonSheetState extends State<_CorporateCarbonSheet> {
  final _companyController = TextEditingController();
  final _emailController = TextEditingController();
  int _tonnesTarget = 100;
  bool _submitting = false;
  bool _submitted = false;

  static const _quickTargets = [50, 100, 500, 1000];

  @override
  void dispose() {
    _companyController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_companyController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty) {
      return;
    }
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _submitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Palette.cream,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
          child: _submitted ? _buildSuccess(context) : _buildForm(context),
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
        const Row(
          children: [
            Icon(Icons.eco, color: Palette.deepGreen),
            SizedBox(width: 10),
            Expanded(
              child: Text('Corporate Carbon Partnership',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          "Tell us a little about your company and target, and our "
          "partnerships team will follow up with a proposal.",
          style: TextStyle(color: Palette.muted, fontSize: 13),
        ),
        const SizedBox(height: 20),
        const Text('Company name',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        const SizedBox(height: 8),
        TextField(
          controller: _companyController,
          decoration: const InputDecoration(hintText: 'e.g. Acme Kenya Ltd'),
        ),
        const SizedBox(height: 16),
        const Text('Work email',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        const SizedBox(height: 8),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(hintText: 'you@company.com'),
        ),
        const SizedBox(height: 18),
        const Text('Target carbon offset (tCO₂e / year)',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final t in _quickTargets)
              ChoiceChip(
                label: Text('$t t'),
                selected: _tonnesTarget == t,
                onSelected: (_) => setState(() => _tonnesTarget = t),
                selectedColor: Palette.deepGreen,
                labelStyle: TextStyle(
                  color: _tonnesTarget == t ? Colors.white : Palette.ink,
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
        const SizedBox(height: 24),
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
                : const Text('Request Proposal'),
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
        const SizedBox(height: 8),
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: Palette.paleGreen,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.eco, color: Palette.deepGreen, size: 34),
        ),
        const SizedBox(height: 20),
        const Text('Request received',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        const SizedBox(height: 8),
        Text(
          'Thanks — our partnerships team will reach out to '
          '${_companyController.text.trim()} about a ${_tonnesTarget}t/year '
          'carbon credit programme shortly.',
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
