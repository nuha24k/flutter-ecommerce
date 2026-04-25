import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();
  @override
  List<Object?> get props => [];
}

/// State awal sebelum animasi masuk
class SplashInitial extends SplashState {
  const SplashInitial();
}

/// State saat animasi masuk berjalan
class SplashAnimating extends SplashState {
  const SplashAnimating();
}

/// State saat user menekan "Get Started" — pindah ke login
class SplashNavigatingToLogin extends SplashState {
  const SplashNavigatingToLogin();
}
