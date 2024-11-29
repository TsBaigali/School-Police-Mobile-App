import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignupUsernameChanged extends SignupEvent {
  final String username;

  const SignupUsernameChanged(this.username);

  @override
  List<Object> get props => [username];
}

class SignupEmailChanged extends SignupEvent {
  final String email;

  const SignupEmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class SignupPasswordChanged extends SignupEvent {
  final String password;

  const SignupPasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class SignupPasswordAgainChanged extends SignupEvent {
  final String confirmPassword;

  const SignupPasswordAgainChanged(this.confirmPassword);

  @override
  List<Object> get props => [confirmPassword];
}

class SignupSubmitted extends SignupEvent {}

class TogglePasswordVisibility extends SignupEvent {
  final bool obscurePassword;

  const TogglePasswordVisibility({required this.obscurePassword});

  @override
  List<Object> get props => [obscurePassword];
}

class ToggleConfirmPasswordVisibility extends SignupEvent {
  final bool obscureConfirmPassword;

  const ToggleConfirmPasswordVisibility({required this.obscureConfirmPassword});

  @override
  List<Object> get props => [obscureConfirmPassword];
}
