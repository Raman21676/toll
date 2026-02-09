import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/themes/app_theme.dart';
import '../../providers/auth_provider.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  Timer? _timer;
  bool _canResend = true;
  int _resendTimer = 60;

  @override
  void initState() {
    super.initState();
    _startVerificationCheck();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startVerificationCheck() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.reloadUser();
      
      if (authProvider.isEmailVerified && mounted) {
        timer.cancel();
        Navigator.pushReplacementNamed(context, AppRoutes.main);
      }
    });
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendTimer = 60;
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer == 0) {
        timer.cancel();
        setState(() {
          _canResend = true;
        });
      } else {
        setState(() {
          _resendTimer--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_unread,
                  size: 60,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 32),
              // Title
              const Text(
                'Verify Your Email',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Description
              Text(
                'We\'ve sent a verification email to:\n${authProvider.firebaseUser?.email ?? ''}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please check your inbox and click the verification link to continue.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 48),
              // Checking indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Waiting for verification...',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Resend button
              TextButton(
                onPressed: _canResend
                    ? () async {
                        final success =
                            await authProvider.resendVerificationEmail();
                        if (success && mounted) {
                          _startResendTimer();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Verification email sent!'),
                              backgroundColor: AppTheme.success,
                            ),
                          );
                        }
                      }
                    : null,
                child: Text(
                  _canResend
                      ? 'Resend Email'
                      : 'Resend in $_resendTimer seconds',
                ),
              ),
              const SizedBox(height: 16),
              // Change email button
              TextButton(
                onPressed: () {
                  authProvider.signOut();
                  Navigator.pushReplacementNamed(context, AppRoutes.register);
                },
                child: const Text('Use a different email'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
