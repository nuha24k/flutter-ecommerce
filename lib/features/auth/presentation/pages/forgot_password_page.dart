import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/colors.dart';
import '../bloc/forgot_password_bloc.dart';
import '../bloc/forgot_password_event.dart';
import '../bloc/forgot_password_state.dart';

/// Forgot Password Screen — Mallzku Style.
///
/// Dua state visual:
/// 1. Form — user memasukkan email
/// 2. Success — tampilan konfirmasi email terkirim
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _handleState(BuildContext context, ForgotPasswordState state) {
    if (state is ForgotPasswordNavigatingToLogin) {
      Navigator.of(context).pop();
    } else if (state is ForgotPasswordFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cobaltBlue,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
            listener: _handleState,
            builder: (context, state) {
              final screenH = MediaQuery.of(context).size.height;
              return Stack(
                children: [
                  // Hero section atas
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: screenH * 0.38,
                    child: _buildHeroSection(context),
                  ),
                  // Form/Success sheet bawah
                  Positioned(
                    top: screenH * 0.28,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: state is ForgotPasswordEmailSent
                        ? _buildSuccessSheet(context, state.email)
                        : _buildFormSheet(context, state),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ── Hero Section ──────────────────────────────────────────
  Widget _buildHeroSection(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Back button
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Brand pill
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.limeGreen,
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Text(
                'MALLZKU',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                  letterSpacing: 2.5,
                ),
              ),
            ),

            const SizedBox(height: 14),

            const Text(
              'Forgot Password? 🔑',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.white,
                height: 1.1,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'No worries, we\'ll send a reset link.',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: AppColors.white,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Form Sheet ────────────────────────────────────────────
  Widget _buildFormSheet(BuildContext context, ForgotPasswordState state) {
    final isLoading = state is ForgotPasswordLoading;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 36, 28, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Reset Password',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Enter the email linked to your account',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 13,
                  color: Colors.grey.shade500,
                ),
              ),

              const SizedBox(height: 32),

              // Email field
              _buildLabel('Email Address'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                onChanged: (v) => context
                    .read<ForgotPasswordBloc>()
                    .add(ForgotPasswordEmailChanged(v)),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Email wajib diisi';
                  if (!v.contains('@')) return 'Format email tidak valid';
                  return null;
                },
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A2E),
                ),
                decoration: _inputDecoration(
                  hint: 'hello@mallzku.com',
                  icon: Icons.mail_outline_rounded,
                ),
              ),

              const SizedBox(height: 32),

              // Send button
              _buildPrimaryButton(
                label: 'Send Reset Link',
                icon: Icons.send_rounded,
                isLoading: isLoading,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    context
                        .read<ForgotPasswordBloc>()
                        .add(const ForgotPasswordSubmitted());
                  }
                },
              ),

              const SizedBox(height: 24),

              // Back to login
              Center(
                child: GestureDetector(
                  onTap: () => context
                      .read<ForgotPasswordBloc>()
                      .add(const ForgotPasswordBackToLoginPressed()),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_rounded,
                          size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 6),
                      Text(
                        'Back to Sign In',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Success Sheet ─────────────────────────────────────────
  Widget _buildSuccessSheet(BuildContext context, String email) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 48, 28, 32),
        child: Column(
          children: [
            // Ikon sukses
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.limeGreen.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mark_email_read_outlined,
                color: AppColors.cobaltBlue,
                size: 38,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Check your email! ✉️',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.black,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'We sent a password reset link to',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              email,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.cobaltBlue,
              ),
            ),

            const SizedBox(height: 36),

            // Open email app button
            _buildPrimaryButton(
              label: 'Open Email App',
              icon: Icons.open_in_new_rounded,
              isLoading: false,
              onTap: () {},
            ),

            const SizedBox(height: 20),

            // Resend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't receive it? ",
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context
                        .read<ForgotPasswordBloc>()
                        .add(const ForgotPasswordSubmitted());
                  },
                  child: const Text(
                    'Resend',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.cobaltBlue,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back_rounded,
                      size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 6),
                  Text(
                    'Back to Sign In',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────

  Widget _buildLabel(String text) => Text(
        text,
        style: const TextStyle(
          fontFamily: 'Outfit',
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1A2E),
        ),
      );

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle:
          TextStyle(fontFamily: 'Outfit', fontSize: 14, color: Colors.grey.shade400),
      prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
      filled: true,
      fillColor: const Color(0xFFF7F8FC),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade100, width: 1.5)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
              const BorderSide(color: AppColors.cobaltBlue, width: 1.5)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 1.5)),
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required IconData icon,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 58,
        decoration: BoxDecoration(
          color: isLoading
              ? AppColors.cobaltBlue.withValues(alpha: 0.7)
              : AppColors.cobaltBlue,
          borderRadius: BorderRadius.circular(100),
          boxShadow: isLoading
              ? []
              : [
                  BoxShadow(
                    color: AppColors.cobaltBlue.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2.5),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.limeGreen,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(icon, color: AppColors.black, size: 14),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
