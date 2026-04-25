import 'package:equatable/equatable.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent();
  @override
  List<Object?> get props => [];
}

/// Dipanggil saat splash screen pertama kali ditampilkan
class SplashStarted extends SplashEvent {
  const SplashStarted();
}

/// Dipanggil saat user menekan tombol "Get Started"
class SplashGetStartedPressed extends SplashEvent {
  const SplashGetStartedPressed();
}
