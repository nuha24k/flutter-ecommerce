import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial({
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
  });

  final String email;
  final String password;
  final bool isPasswordVisible;

  LoginInitial copyWith({
    String? email,
    String? password,
    bool? isPasswordVisible,
  }) {
    return LoginInitial(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }

  @override
  List<Object?> get props => [email, password, isPasswordVisible];
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  const LoginSuccess();
}

class LoginFailure extends LoginState {
  final String message;
  const LoginFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class LoginNavigatingToSignUp extends LoginState {
  const LoginNavigatingToSignUp();
}
