import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object?> get props => [];
}

/// Email input berubah
class LoginEmailChanged extends LoginEvent {
  final String email;
  const LoginEmailChanged(this.email);
  @override
  List<Object?> get props => [email];
}

/// Password input berubah
class LoginPasswordChanged extends LoginEvent {
  final String password;
  const LoginPasswordChanged(this.password);
  @override
  List<Object?> get props => [password];
}

/// Toggle visibilitas password
class LoginPasswordVisibilityToggled extends LoginEvent {
  const LoginPasswordVisibilityToggled();
}

/// Tombol "Sign In" ditekan
class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}

/// Tombol "Sign Up" ditekan
class LoginSignUpPressed extends LoginEvent {
  const LoginSignUpPressed();
}
