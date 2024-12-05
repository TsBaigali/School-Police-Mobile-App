import 'package:equatable/equatable.dart';

class SignupState extends Equatable {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String errorMessage;
  final bool obscurePassword; // To toggle password visibility
  final bool obscureConfirmPassword; // To toggle confirm password visibility

  const SignupState({
    this.username = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isSubmitting = false,
    this.isSuccess = false,
    this.isFailure = false,
    this.errorMessage = '',
    this.obscurePassword = true, // Initially hide password
    this.obscureConfirmPassword = true, // Initially hide confirm password
  });

  SignupState copyWith({
    String? username,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    String? errorMessage,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
  }) {
    return SignupState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      errorMessage: errorMessage ?? this.errorMessage,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
    );
  }

  @override
  List<Object?> get props => [
        username,
        email,
        password,
        confirmPassword,
        isSubmitting,
        isSuccess,
        isFailure,
        errorMessage,
        obscurePassword,
        obscureConfirmPassword,
      ];
}
