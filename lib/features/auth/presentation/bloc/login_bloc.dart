import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginInitial()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginPasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginSignUpPressed>(_onSignUpPressed);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    final current = state is LoginInitial ? state as LoginInitial : const LoginInitial();
    emit(current.copyWith(email: event.email));
  }

  void _onPasswordChanged(LoginPasswordChanged event, Emitter<LoginState> emit) {
    final current = state is LoginInitial ? state as LoginInitial : const LoginInitial();
    emit(current.copyWith(password: event.password));
  }

  void _onPasswordVisibilityToggled(
    LoginPasswordVisibilityToggled event,
    Emitter<LoginState> emit,
  ) {
    if (state is LoginInitial) {
      final current = state as LoginInitial;
      emit(current.copyWith(isPasswordVisible: !current.isPasswordVisible));
    }
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    final current = state is LoginInitial
        ? state as LoginInitial
        : const LoginInitial();

    emit(const LoginLoading());
    await Future<void>.delayed(const Duration(seconds: 2));

    // Validasi dummy credentials
    if (current.email == 'nuha@gmail.com' &&
        current.password == '12345678') {
      emit(const LoginSuccess());
    } else {
      emit(const LoginFailure('Email atau password salah. Coba lagi.'));
    }
  }

  void _onSignUpPressed(LoginSignUpPressed event, Emitter<LoginState> emit) {
    emit(const LoginNavigatingToSignUp());
  }
}
