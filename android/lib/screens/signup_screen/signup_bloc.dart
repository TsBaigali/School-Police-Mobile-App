import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

    try {
      // Create user with Firebase Authentication
      final firebase_auth.UserCredential userCredential =
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );

      final userId = userCredential.user?.uid;

      if (userId != null) {
        // Save additional user details to Firestore
        await _firestore.collection('user').doc(userId).set({
          'username': state.username,
          'email': state.email,
          'createdAt': DateTime.now().toIso8601String(),
          'fcmToken': await firebase_auth.FirebaseAuth.instance.currentUser
              ?.getIdToken(), // Optional FCM Token
        });

        emit(state.copyWith(
          isSubmitting: false,
          isSuccess: true,
          isFailure: false,
        ));
      } else {
        emit(state.copyWith(
          isSubmitting: false,
          isSuccess: false,
          isFailure: true,
          errorMessage: 'User creation failed',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        isFailure: true,
        errorMessage: 'Error: ${e.toString()}',
      ));
    }
  }

  Future<bool> _isEmailValid(String email) async {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }
}
