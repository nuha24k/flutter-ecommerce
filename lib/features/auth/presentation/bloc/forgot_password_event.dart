import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();
  @override
  List<Object?> get props => [];
}

/// Email input berubah
class ForgotPasswordEmailChanged extends ForgotPasswordEvent {
  final String email;
  const ForgotPasswordEmailChanged(this.email);
  @override
  List<Object?> get props => [email];
}

/// Tombol "Send Reset Link" ditekan
class ForgotPasswordSubmitted extends ForgotPasswordEvent {
  const ForgotPasswordSubmitted();
}

/// Kembali ke halaman login
class ForgotPasswordBackToLoginPressed extends ForgotPasswordEvent {
  const ForgotPasswordBackToLoginPressed();
}
