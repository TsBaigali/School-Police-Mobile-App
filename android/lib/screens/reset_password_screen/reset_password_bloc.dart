import 'package:flutter_bloc/flutter_bloc.dart';
import 'reset_password_event.dart';
import 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc() : super(const ResetPasswordState()) {
    on<ToggleNewPasswordVisibility>(_onToggleNewPasswordVisibility);
    on<ToggleConfirmPasswordVisibility>(_onToggleConfirmPasswordVisibility);
    on<NewPasswordChanged>(_onNewPasswordChanged);
    on<ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<SubmitResetPassword>(_onSubmitResetPassword);
  }

  void _onToggleNewPasswordVisibility(
      ToggleNewPasswordVisibility event, Emitter<ResetPasswordState> emit) {
    emit(state.copyWith(obscureNewPassword: !state.obscureNewPassword));
  }

  void _onToggleConfirmPasswordVisibility(
      ToggleConfirmPasswordVisibility event, Emitter<ResetPasswordState> emit) {
    emit(state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword));
  }

  void _onNewPasswordChanged(
      NewPasswordChanged event, Emitter<ResetPasswordState> emit) {
    emit(state.copyWith(newPassword: event.newPassword));
  }

  void _onConfirmPasswordChanged(
      ConfirmPasswordChanged event, Emitter<ResetPasswordState> emit) {
    emit(state.copyWith(confirmPassword: event.confirmPassword));
  }

  void _onSubmitResetPassword(
      SubmitResetPassword event, Emitter<ResetPasswordState> emit) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: ''));

    // Validate password
    if (!_isValidPassword(state.newPassword)) {
      emit(state.copyWith(
          isSubmitting: false,
          errorMessage:
              'Password must be at least 6 characters long and include a capital letter.'));
      return;
    }

    // Check if passwords match
    if (state.newPassword != state.confirmPassword) {
      emit(state.copyWith(
          isSubmitting: false, errorMessage: 'Passwords do not match.'));
      return;
    }

    // Simulate a network request
    await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(isSubmitting: false));
    // You can add additional logic after password reset is successful.
  }

  bool _isValidPassword(String password) {
    if (password.length < 6) return false;
    final hasUpperCase = password.contains(RegExp(r'[A-Z]'));
    return hasUpperCase;
  }
}
