import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();
  @override
  List<Object?> get props => [];
}

/// Nama input berubah
class SignUpNameChanged extends SignUpEvent {
  final String name;
  const SignUpNameChanged(this.name);
  @override
  List<Object?> get props => [name];
}

/// Email input berubah
class SignUpEmailChanged extends SignUpEvent {
  final String email;
  const SignUpEmailChanged(this.email);
  @override
  List<Object?> get props => [email];
}

/// Password input berubah
class SignUpPasswordChanged extends SignUpEvent {
  final String password;
  const SignUpPasswordChanged(this.password);
  @override
  List<Object?> get props => [password];
}

/// Confirm password input berubah
class SignUpConfirmPasswordChanged extends SignUpEvent {
  final String confirmPassword;
  const SignUpConfirmPasswordChanged(this.confirmPassword);
  @override
  List<Object?> get props => [confirmPassword];
}

/// Toggle visibilitas password
class SignUpPasswordVisibilityToggled extends SignUpEvent {
  const SignUpPasswordVisibilityToggled();
}

/// Toggle visibilitas confirm password
class SignUpConfirmPasswordVisibilityToggled extends SignUpEvent {
  const SignUpConfirmPasswordVisibilityToggled();
}

/// Toggle persetujuan terms & conditions
class SignUpTermsToggled extends SignUpEvent {
  const SignUpTermsToggled();
}

/// Tombol "Create Account" ditekan
class SignUpSubmitted extends SignUpEvent {
  const SignUpSubmitted();
}

/// Kembali ke halaman login
class SignUpBackToLoginPressed extends SignUpEvent {
  const SignUpBackToLoginPressed();
}
