import 'package:flutter_bloc/flutter_bloc.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(const ForgotPasswordInitial()) {
    on<ForgotPasswordEmailChanged>(_onEmailChanged);
    on<ForgotPasswordSubmitted>(_onSubmitted);
    on<ForgotPasswordBackToLoginPressed>(_onBackToLogin);
  }

  void _onEmailChanged(
    ForgotPasswordEmailChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    final current = state is ForgotPasswordInitial
        ? state as ForgotPasswordInitial
        : const ForgotPasswordInitial();
    emit(current.copyWith(email: event.email));
  }

  Future<void> _onSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(const ForgotPasswordLoading());
    await Future<void>.delayed(const Duration(seconds: 2));
    // TODO: Hubungkan ke repository — kirim email reset
    final email = state is ForgotPasswordInitial
        ? (state as ForgotPasswordInitial).email
        : '';
    emit(ForgotPasswordEmailSent(email));
  }

  void _onBackToLogin(
    ForgotPasswordBackToLoginPressed event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(const ForgotPasswordNavigatingToLogin());
  }
}
