import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A "join the waitlist" popup dialog. Shown automatically when the landing
/// page loads (see `LandingScreen`), separate from the always-visible
/// [WaitlistSection] form further down the page — both write to the same
/// `waitlist` collection in Cloud Firestore, just with a different `source`
/// tag so submissions can be told apart.
class JoinWaitlistDialog extends StatefulWidget {
  const JoinWaitlistDialog({super.key});

  /// Shows the dialog on top of [context], if one isn't already open.
  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const JoinWaitlistDialog(),
    );
  }

  @override
  State<JoinWaitlistDialog> createState() => _JoinWaitlistDialogState();
}

class _JoinWaitlistDialogState extends State<JoinWaitlistDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _submitting = false;
  bool _submitted = false;
  String? _error;

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await FirebaseFirestore.instance.collection('waitlist').add({
        'email': _emailController.text.trim().toLowerCase(),
        'createdAt': FieldValue.serverTimestamp(),
        'source': 'landing_page_modal',
      });
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _submitted = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = "Something went wrong — please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Palette.cream,
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            child: _submitted ? _buildSuccess() : _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      key: const ValueKey('waitlist-dialog-form'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Palette.muted),
            tooltip: 'Close',
          ),
        ),
        const Eyebrow('Coming Soon', color: Palette.deepGreen),
        const SizedBox(height: 10),
        Text('Join the Waitlist', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        const Text(
          "Be first to hear when new listings — like the bee hive "
          "collective — open for investment.",
          style: TextStyle(color: Palette.muted, fontSize: 14.5, height: 1.5),
        ),
        const SizedBox(height: 22),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  hintText: 'you@example.com',
                  errorText: _error,
                ),
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) return 'Enter your email';
                  if (!_emailPattern.hasMatch(v)) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 52,
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
                      : const Text('Notify Me'),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Maybe later',
                    style: TextStyle(color: Palette.muted),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuccess() {
    return Column(
      key: const ValueKey('waitlist-dialog-success'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Palette.paleGreen,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Palette.deepGreen, size: 32),
              SizedBox(height: 10),
              Text(
                "You're on the list! We'll email you when new listings open.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Palette.deepGreen,
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ),
      ],
    );
  }
}
