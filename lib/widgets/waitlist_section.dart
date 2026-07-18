import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'reveal.dart';

/// A "join the waitlist" email capture section. Submissions are written to
/// the `waitlist` collection in Cloud Firestore — see the Firestore
/// security rules alongside this file, which allow public **create** only
/// (no read/update/delete), so emails can be collected without exposing
/// them back to the browser.
class WaitlistSection extends StatefulWidget {
  final bool isWide;
  const WaitlistSection({super.key, required this.isWide});

  @override
  State<WaitlistSection> createState() => _WaitlistSectionState();
}

class _WaitlistSectionState extends State<WaitlistSection> {
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
        'source': 'landing_page',
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
    return Container(
      width: double.infinity,
      color: Palette.cream,
      padding: EdgeInsets.symmetric(
        horizontal: widget.isWide ? 80 : 24,
        vertical: widget.isWide ? 72 : 48,
      ),
      child: Column(
        children: [
          const Eyebrow('Coming Soon', color: Palette.deepGreen),
          const SizedBox(height: 10),
          Text('Join the Waitlist', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: const Text(
              "Be first to hear when new listings — like the bee hive "
              "collective — open for investment.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Palette.muted, fontSize: 14.5, height: 1.5),
            ),
          ),
          const SizedBox(height: 28),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Reveal(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                child: _submitted ? _buildSuccess() : _buildForm(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey('waitlist-form'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          widget.isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildEmailField()),
                    const SizedBox(width: 12),
                    _buildSubmitButton(),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildEmailField(),
                    const SizedBox(height: 12),
                    _buildSubmitButton(),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
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
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
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
    );
  }

  Widget _buildSuccess() {
    return Container(
      key: const ValueKey('waitlist-success'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Palette.paleGreen,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.check_circle, color: Palette.deepGreen),
          SizedBox(width: 10),
          Flexible(
            child: Text(
              "You're on the list! We'll email you when new listings open.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Palette.deepGreen,
                fontWeight: FontWeight.w700,
                fontSize: 13.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
