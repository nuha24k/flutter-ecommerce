import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../bloc/splash_bloc.dart';
import '../bloc/splash_event.dart';
import '../bloc/splash_state.dart';
import '../widgets/splash_widgets.dart';
import '../../../auth/presentation/bloc/login_bloc.dart';
import '../../../auth/presentation/pages/login_page.dart';

/// Splash Screen utama Mallzku.
///
/// Menampilkan:
/// - Badge "Holiday Market"
/// - Heading bold
/// - Deskripsi singkat
/// - Bento photo grid (3 sel fashion)
/// - Tombol "Get Started" lebar penuh di bawah bento
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );

    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    context.read<SplashBloc>().add(const SplashStarted());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _handleState(BuildContext context, SplashState state) {
    if (state is SplashAnimating) {
      _ctrl.forward();
    } else if (state is SplashNavigatingToLogin) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (ctx, animation, secondaryAnimation) => BlocProvider(
            create: (c) => LoginBloc(),
            child: const LoginPage(),
          ),
          transitionsBuilder: (ctx, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashBloc, SplashState>(
      listener: _handleState,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.cobaltBlue,
          body: SafeArea(
            bottom: false,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: _buildBody(context),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),

        // Badge
        const Center(child: HolidayMarketBadge()),
        const SizedBox(height: 18),

        // Heading
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'DEFINE YOURSELF IN YOUR UNIQUE WAY',
            textAlign: TextAlign.center,
            style: AppTextStyles.headingLarge,
          ),
        ),
        const SizedBox(height: 12),

        // Deskripsi
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 36),
          child: Text(
            "With Mallzku, you don't need to be anyone, just be yourself",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyDescription,
          ),
        ),
        const SizedBox(height: 20),

        // Bento Grid
        const Expanded(child: BentoPhotoGrid()),
        const SizedBox(height: 20),

        // Tombol Get Started — lebar penuh, di bawah bento
        GetStartedButton(
          onPressed: () => context
              .read<SplashBloc>()
              .add(const SplashGetStartedPressed()),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
