import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/colors.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import '../bloc/forgot_password_bloc.dart';
import '../bloc/sign_up_bloc.dart';
import 'forgot_password_page.dart';
import 'sign_up_page.dart';
import '../../../home/presentation/pages/home_page.dart';

/// Login Screen Mallzku.
///
/// Design: Cobalt Blue background atas (hero section),
/// white rounded sheet bawah berisi form login.
/// Aksen lime green pada tombol utama.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
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
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _handleState(BuildContext context, LoginState state) {
    if (state is LoginSuccess) {
      // Navigasi ke HomePage, hapus semua route sebelumnya
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (ctx, animation, secondaryAnimation) =>
              const HomePage(),
          transitionsBuilder:
              (ctx, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
        (route) => false,
      );
    } else if (state is LoginFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } else if (state is LoginNavigatingToSignUp) {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (ctx, animation, secondaryAnimation) => BlocProvider(
            create: (c) => SignUpBloc(),
            child: const SignUpPage(),
          ),
          transitionsBuilder: (ctx, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
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
          child: BlocConsumer<LoginBloc, LoginState>(
            listener: _handleState,
            builder: (context, state) => _buildLayout(context, state),
          ),
        ),
      ),
    );
  }

  Widget _buildLayout(BuildContext context, LoginState state) {
    final isLoading = state is LoginLoading;
    final formState = state is LoginInitial ? state : const LoginInitial();
    final screenH = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: screenH * 0.38,
          child: _buildHeroSection(context),
        ),

        Positioned(
          top: screenH * 0.28,
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildFormSheet(context, formState, isLoading),
        ),
      ],
    );
  }


  Widget _buildHeroSection(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Back button
            // GestureDetector(
            //   onTap: () => Navigator.of(context).maybePop(),
            //   child: Container(
            //     padding: const EdgeInsets.all(10),
            //     decoration: BoxDecoration(
            //       color: Colors.white.withValues(alpha: 0.15),
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     child: const Icon(
            //       Icons.arrow_back_rounded,
            //       color: AppColors.white,
            //       size: 20,
            //     ),
            //   ),
            // ),

            const SizedBox(height: 24),

            // Brand logo pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
              'Welcome Back! 👋',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 34,
                fontWeight: FontWeight.w900,
                color: AppColors.white,
                height: 1.1,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Sign in to your account to continue.',
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
  Widget _buildFormSheet(
    BuildContext context,
    LoginInitial formState,
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
        padding: const EdgeInsets.fromLTRB(28, 36, 28, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Judul
              const Text(
                'Sign In',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Enter your credentials to continue',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade500,
                ),
              ),

              const SizedBox(height: 32),

              // Email field
              _buildLabel('Email Address'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _emailCtrl,
                hint: 'hello@mallzku.com',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.mail_outline_rounded,
                onChanged: (v) =>
                    context.read<LoginBloc>().add(LoginEmailChanged(v)),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Email wajib diisi';
                  if (!v.contains('@')) return 'Format email tidak valid';
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Password field
              _buildLabel('Password'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _passCtrl,
                hint: '••••••••',
                isPassword: true,
                isPasswordVisible: formState.isPasswordVisible,
                prefixIcon: Icons.lock_outline_rounded,
                onChanged: (v) =>
                    context.read<LoginBloc>().add(LoginPasswordChanged(v)),
                onTogglePassword: () => context
                    .read<LoginBloc>()
                    .add(const LoginPasswordVisibilityToggled()),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Password wajib diisi';
                  if (v.length < 6) return 'Minimal 6 karakter';
                  return null;
                },
              ),

              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (ctx, animation, secondaryAnimation) =>
                            BlocProvider(
                          create: (c) => ForgotPasswordBloc(),
                          child: const ForgotPasswordPage(),
                        ),
                        transitionsBuilder:
                            (ctx, animation, secondaryAnimation, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.0, 1.0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            )),
                            child: child,
                          );
                        },
                        transitionDuration:
                            const Duration(milliseconds: 400),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.cobaltBlue,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Sign In button
              _buildSignInButton(isLoading),

              const SizedBox(height: 28),

              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade200)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      'or continue with',
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

              const SizedBox(height: 20),

              // Social buttons
              Row(
                children: [
                  Expanded(child: _buildSocialButton('G', 'Google')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildSocialButton('A', 'Apple')),
                ],
              ),

              const SizedBox(height: 32),

              // Sign up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context
                        .read<LoginBloc>()
                        .add(const LoginSignUpPressed()),
                    child: const Text(
                      'Sign Up',
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

  // ── Helpers ───────────────────────────────────────────────

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Outfit',
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A2E),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
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
        hintStyle: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 14,
          color: Colors.grey.shade400,
        ),
        prefixIcon: Icon(prefixIcon, color: Colors.grey.shade400, size: 20),
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
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade100, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
              const BorderSide(color: AppColors.cobaltBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildSignInButton(bool isLoading) {
    return GestureDetector(
      onTap: isLoading
          ? null
          : () {
              if (_formKey.currentState!.validate()) {
                context.read<LoginBloc>().add(const LoginSubmitted());
              }
            },
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
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sign In',
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
                        color: AppColors.limeGreen,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.black,
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
