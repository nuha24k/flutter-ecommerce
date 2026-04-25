import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_event.dart';
import 'splash_state.dart';

/// BLoC untuk Splash Screen Mallzku.
///
/// Alur state: [SplashInitial] → [SplashAnimating] → [SplashNavigatingToLogin]
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(const SplashInitial()) {
    on<SplashStarted>(_onStarted);
    on<SplashGetStartedPressed>(_onGetStartedPressed);
  }

  Future<void> _onStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    emit(const SplashAnimating());
  }

  void _onGetStartedPressed(
    SplashGetStartedPressed event,
    Emitter<SplashState> emit,
  ) {
    emit(const SplashNavigatingToLogin());
  }
}
