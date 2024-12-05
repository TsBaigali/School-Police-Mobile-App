import 'package:equatable/equatable.dart';

abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object> get props => [];
}

// Event to toggle the visibility of the new password
class ToggleNewPasswordVisibility extends ResetPasswordEvent {}

// Event to toggle the visibility of the confirm password
class ToggleConfirmPasswordVisibility extends ResetPasswordEvent {}

// Event when the new password field is updated
class NewPasswordChanged extends ResetPasswordEvent {
  final String newPassword;

  const NewPasswordChanged(this.newPassword);

  @override
  List<Object> get props => [newPassword];
}

// Event when the confirm password field is updated
class ConfirmPasswordChanged extends ResetPasswordEvent {
  final String confirmPassword;

  const ConfirmPasswordChanged(this.confirmPassword);

  @override
  List<Object> get props => [confirmPassword];
}

// Event to submit the form
class SubmitResetPassword extends ResetPasswordEvent {}
