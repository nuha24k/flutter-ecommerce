import 'package:equatable/equatable.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();
  @override
  List<Object?> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {
  const ForgotPasswordInitial({this.email = ''});
  final String email;

  ForgotPasswordInitial copyWith({String? email}) =>
      ForgotPasswordInitial(email: email ?? this.email);

  @override
  List<Object?> get props => [email];
}

class ForgotPasswordLoading extends ForgotPasswordState {
  const ForgotPasswordLoading();
}

/// Email reset berhasil dikirim
class ForgotPasswordEmailSent extends ForgotPasswordState {
  final String email;
  const ForgotPasswordEmailSent(this.email);
  @override
  List<Object?> get props => [email];
}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String message;
  const ForgotPasswordFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class ForgotPasswordNavigatingToLogin extends ForgotPasswordState {
  const ForgotPasswordNavigatingToLogin();
}
