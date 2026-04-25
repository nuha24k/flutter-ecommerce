import 'package:flutter_bloc/flutter_bloc.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(const SignUpInitial()) {
    on<SignUpNameChanged>(_onNameChanged);
    on<SignUpEmailChanged>(_onEmailChanged);
    on<SignUpPasswordChanged>(_onPasswordChanged);
    on<SignUpConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<SignUpPasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<SignUpConfirmPasswordVisibilityToggled>(
        _onConfirmPasswordVisibilityToggled);
    on<SignUpTermsToggled>(_onTermsToggled);
    on<SignUpSubmitted>(_onSubmitted);
    on<SignUpBackToLoginPressed>(_onBackToLogin);
  }

  SignUpInitial get _current =>
      state is SignUpInitial ? state as SignUpInitial : const SignUpInitial();

  void _onNameChanged(SignUpNameChanged e, Emitter<SignUpState> emit) =>
      emit(_current.copyWith(name: e.name));

  void _onEmailChanged(SignUpEmailChanged e, Emitter<SignUpState> emit) =>
      emit(_current.copyWith(email: e.email));

  void _onPasswordChanged(SignUpPasswordChanged e, Emitter<SignUpState> emit) =>
      emit(_current.copyWith(password: e.password));

  void _onConfirmPasswordChanged(
          SignUpConfirmPasswordChanged e, Emitter<SignUpState> emit) =>
      emit(_current.copyWith(confirmPassword: e.confirmPassword));

  void _onPasswordVisibilityToggled(
      SignUpPasswordVisibilityToggled e, Emitter<SignUpState> emit) {
    emit(_current.copyWith(isPasswordVisible: !_current.isPasswordVisible));
  }

  void _onConfirmPasswordVisibilityToggled(
      SignUpConfirmPasswordVisibilityToggled e, Emitter<SignUpState> emit) {
    emit(_current.copyWith(
        isConfirmPasswordVisible: !_current.isConfirmPasswordVisible));
  }

  void _onTermsToggled(SignUpTermsToggled e, Emitter<SignUpState> emit) =>
      emit(_current.copyWith(isTermsAccepted: !_current.isTermsAccepted));

  Future<void> _onSubmitted(
      SignUpSubmitted e, Emitter<SignUpState> emit) async {
    emit(const SignUpLoading());
    await Future<void>.delayed(const Duration(seconds: 2));
    // TODO: Hubungkan ke repository — registrasi user
    emit(const SignUpSuccess());
  }

  void _onBackToLogin(SignUpBackToLoginPressed e, Emitter<SignUpState> emit) =>
      emit(const SignUpNavigatingToLogin());
}
