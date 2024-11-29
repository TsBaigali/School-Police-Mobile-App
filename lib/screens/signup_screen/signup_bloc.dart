import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final String baseUrl =
      'https://backend-api-491759785783.asia-northeast1.run.app/';

  SignupBloc() : super(const SignupState()) {
    on<SignupUsernameChanged>(_onUsernameChanged);
    on<SignupEmailChanged>(_onEmailChanged);
    on<SignupPasswordChanged>(_onPasswordChanged);
    on<SignupPasswordAgainChanged>(_onPasswordAgainChanged);
    on<SignupSubmitted>(_onSignupSubmitted);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
    on<ToggleConfirmPasswordVisibility>(_onToggleConfirmPasswordVisibility);
  }

  void _onUsernameChanged(
      SignupUsernameChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(username: event.username));
  }

  void _onEmailChanged(SignupEmailChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(
      SignupPasswordChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onPasswordAgainChanged(
      SignupPasswordAgainChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(confirmPassword: event.confirmPassword));
  }

  void _onTogglePasswordVisibility(
      TogglePasswordVisibility event, Emitter<SignupState> emit) {
    emit(state.copyWith(obscurePassword: !event.obscurePassword));
  }

  void _onToggleConfirmPasswordVisibility(
      ToggleConfirmPasswordVisibility event, Emitter<SignupState> emit) {
    emit(state.copyWith(obscureConfirmPassword: !event.obscureConfirmPassword));
  }

  Future<void> _onSignupSubmitted(
      SignupSubmitted event, Emitter<SignupState> emit) async {
    emit(state.copyWith(isSubmitting: true));

    // Validate inputs locally
    if (state.username.isEmpty ||
        state.email.isEmpty ||
        state.password.isEmpty) {
      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        isFailure: true,
        errorMessage: 'Fields cannot be empty',
      ));
      return;
    }

    if (!await _isEmailValid(state.email)) {
      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        isFailure: true,
        errorMessage: 'Invalid email format',
      ));
      return;
    }

    if (state.password != state.confirmPassword) {
      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        isFailure: true,
        errorMessage: 'Passwords do not match',
      ));
      return;
    }

    // Send data to backend
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'name': state.username,
          'email': state.email,
          'password': state.password,
          'address': 'Default address', // Default value
          'phoneNumber': '0000000000', // Default value
          'rating': 0, // Default value
          'totalWorkCount': 0, // Default value
          'userid': 123 // Default value
        }),
      );

      if (response.statusCode == 200) {
        emit(state.copyWith(
          isSubmitting: false,
          isSuccess: true,
          isFailure: false,
        ));
      } else {
        final errorResponse = json.decode(response.body);
        emit(state.copyWith(
          isSubmitting: false,
          isSuccess: false,
          isFailure: true,
          errorMessage: errorResponse['message'] ?? 'Registration failed',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        isFailure: true,
        errorMessage: 'Failed to connect to the server',
      ));
    }
  }

  Future<bool> _isEmailValid(String email) async {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }
}
