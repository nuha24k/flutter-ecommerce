import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/colors.dart';
import '../bloc/sign_up_bloc.dart';
import '../bloc/sign_up_event.dart';
import '../bloc/sign_up_state.dart';

/// Sign Up Screen — Mallzku Style.
///
/// Form registrasi: Nama, Email, Password, Confirm Password, Terms checkbox.
/// Pada state [SignUpSuccess] tampilkan halaman konfirmasi akun berhasil dibuat.
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
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
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  void _handleState(BuildContext context, SignUpState state) {
    if (state is SignUpNavigatingToLogin) {
      Navigator.of(context).pop();
    } else if (state is SignUpFailure) {
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
          child: BlocConsumer<SignUpBloc, SignUpState>(
            listener: _handleState,
            builder: (context, state) {
              if (state is SignUpSuccess) {
                return _buildSuccessView(context);
              }

              final screenH = MediaQuery.of(context).size.height;
              final formState =
                  state is SignUpInitial ? state : const SignUpInitial();
              final isLoading = state is SignUpLoading;

              return Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: screenH * 0.32,
                    child: _buildHeroSection(context),
                  ),
                  Positioned(
                    top: screenH * 0.22,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _buildFormSheet(context, formState, isLoading),
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

            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back_rounded,
                    color: AppColors.white, size: 20),
              ),
            ),

            const SizedBox(height: 20),

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

            const SizedBox(height: 12),

            const Text(
              'Create Account 🚀',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: AppColors.white,
                height: 1.1,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              'Join Mallzku and define your style.',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Form Sheet ────────────────────────────────────────────
  Widget _buildFormSheet(
    BuildContext context,
    SignUpInitial formState,
    bool isLoading,
  ) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 32, 28, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Sign Up',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Fill in your details to get started',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 13,
                  color: Colors.grey.shade500,
                ),
              ),

              const SizedBox(height: 28),

              // Full Name
              _buildLabel('Full Name'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _nameCtrl,
                hint: 'John Doe',
                icon: Icons.person_outline_rounded,
                onChanged: (v) =>
                    context.read<SignUpBloc>().add(SignUpNameChanged(v)),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Nama wajib diisi';
                  if (v.trim().length < 2) return 'Nama minimal 2 karakter';
                  return null;
                },
              ),

              const SizedBox(height: 18),

              // Email
              _buildLabel('Email Address'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _emailCtrl,
                hint: 'hello@mallzku.com',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                onChanged: (v) =>
                    context.read<SignUpBloc>().add(SignUpEmailChanged(v)),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Email wajib diisi';
                  if (!v.contains('@')) return 'Format email tidak valid';
                  return null;
                },
              ),

              const SizedBox(height: 18),

              // Password
              _buildLabel('Password'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _passCtrl,
                hint: '••••••••',
                icon: Icons.lock_outline_rounded,
                isPassword: true,
                isPasswordVisible: formState.isPasswordVisible,
                onChanged: (v) =>
                    context.read<SignUpBloc>().add(SignUpPasswordChanged(v)),
                onTogglePassword: () => context
                    .read<SignUpBloc>()
                    .add(const SignUpPasswordVisibilityToggled()),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Password wajib diisi';
                  if (v.length < 8) return 'Minimal 8 karakter';
                  if (!RegExp(r'[A-Z]').hasMatch(v)) {
                    return 'Harus mengandung huruf kapital';
                  }
                  if (!RegExp(r'[0-9]').hasMatch(v)) {
                    return 'Harus mengandung angka';
                  }
                  return null;
                },
              ),

              // Password strength indicator
              const SizedBox(height: 8),
              _buildPasswordStrengthBar(formState.password),

              const SizedBox(height: 18),

              // Confirm Password
              _buildLabel('Confirm Password'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _confirmPassCtrl,
                hint: '••••••••',
                icon: Icons.lock_outline_rounded,
                isPassword: true,
                isPasswordVisible: formState.isConfirmPasswordVisible,
                onChanged: (v) => context
                    .read<SignUpBloc>()
                    .add(SignUpConfirmPasswordChanged(v)),
                onTogglePassword: () => context
                    .read<SignUpBloc>()
                    .add(const SignUpConfirmPasswordVisibilityToggled()),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Konfirmasi password wajib diisi';
                  }
                  if (v != _passCtrl.text) return 'Password tidak cocok';
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Terms & Conditions
              GestureDetector(
                onTap: () =>
                    context.read<SignUpBloc>().add(const SignUpTermsToggled()),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: formState.isTermsAccepted
                            ? AppColors.cobaltBlue
                            : Colors.transparent,
                        border: Border.all(
                          color: formState.isTermsAccepted
                              ? AppColors.cobaltBlue
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: formState.isTermsAccepted
                          ? const Icon(Icons.check_rounded,
                              color: Colors.white, size: 14)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                          children: const [
                            TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms & Conditions',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.cobaltBlue,
                              ),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.cobaltBlue,
                              ),
                            ),
                            TextSpan(text: ' of Mallzku'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Create Account button
              _buildCreateAccountButton(isLoading, formState.isTermsAccepted),

              const SizedBox(height: 12),

              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade200)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      'or sign up with',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 12,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade200)),
                ],
              ),

              const SizedBox(height: 16),

              // Social buttons
              Row(
                children: [
                  Expanded(child: _buildSocialButton('G', 'Google')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildSocialButton('A', 'Apple')),
                ],
              ),

              const SizedBox(height: 28),

              // Already have account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context
                        .read<SignUpBloc>()
                        .add(const SignUpBackToLoginPressed()),
                    child: const Text(
                      'Sign In',
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
            ],
          ),
        ),
      ),
    );
  }

  // ── Success View ──────────────────────────────────────────
  Widget _buildSuccessView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated success icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.limeGreen,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.limeGreen.withValues(alpha: 0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_rounded,
                color: AppColors.black,
                size: 48,
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'Account Created! 🎉',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AppColors.white,
                height: 1.1,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Welcome to Mallzku! Your account is ready. Start exploring unique fashion.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),

            const SizedBox(height: 48),

            // Go to login
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: double.infinity,
                height: 58,
                decoration: BoxDecoration(
                  color: AppColors.limeGreen,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.limeGreen.withValues(alpha: 0.45),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Go to Sign In',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward_rounded,
                        color: AppColors.black, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Password Strength Bar ─────────────────────────────────
  Widget _buildPasswordStrengthBar(String password) {
    int strength = 0;
    if (password.length >= 8) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[!@#\$&*~]').hasMatch(password)) strength++;

    final labels = ['', 'Weak', 'Fair', 'Good', 'Strong'];
    final colors = [
      Colors.grey.shade200,
      Colors.red.shade400,
      Colors.orange.shade400,
      Colors.blue.shade400,
      AppColors.limeGreen,
    ];

    if (password.isEmpty) return const SizedBox.shrink();

    return Row(
      children: [
        ...List.generate(4, (i) {
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
              decoration: BoxDecoration(
                color: i < strength ? colors[strength] : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          );
        }),
        const SizedBox(width: 10),
        Text(
          strength > 0 ? labels[strength] : '',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: strength > 0 ? colors[strength] : Colors.transparent,
          ),
        ),
      ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool isPasswordVisible = false,
    ValueChanged<String>? onChanged,
    VoidCallback? onTogglePassword,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword && !isPasswordVisible,
      onChanged: onChanged,
      validator: validator,
      style: const TextStyle(
        fontFamily: 'Outfit',
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1A1A2E),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            TextStyle(fontFamily: 'Outfit', fontSize: 14, color: Colors.grey.shade400),
        prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
        suffixIcon: isPassword
            ? GestureDetector(
                onTap: onTogglePassword,
                child: Icon(
                  isPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFF7F8FC),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none),
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
      ),
    );
  }

  Widget _buildCreateAccountButton(bool isLoading, bool isTermsAccepted) {
    final isEnabled = isTermsAccepted && !isLoading;
    return GestureDetector(
      onTap: isEnabled
          ? () {
              if (_formKey.currentState!.validate()) {
                context.read<SignUpBloc>().add(const SignUpSubmitted());
              }
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 58,
        decoration: BoxDecoration(
          color: isEnabled
              ? AppColors.cobaltBlue
              : AppColors.cobaltBlue.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(100),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: AppColors.cobaltBlue.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
              : [],
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
                    const Text(
                      'Create Account',
                      style: TextStyle(
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
                        color: isEnabled
                            ? AppColors.limeGreen
                            : Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(
                        Icons.person_add_rounded,
                        color: isEnabled ? AppColors.black : Colors.white,
                        size: 14,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String iconLabel, String name) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: iconLabel == 'G'
                  ? const Color(0xFF4285F4)
                  : AppColors.black,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                iconLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Outfit',
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            name,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ],
      ),
    );
  }
}
