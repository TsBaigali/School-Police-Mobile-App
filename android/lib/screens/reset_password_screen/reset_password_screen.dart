import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_police/screens/login_screen/login_screen.dart';
import 'reset_password_bloc.dart';
import 'reset_password_event.dart';
import 'reset_password_state.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => ResetPasswordBloc(),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
              listener: (context, state) {
                if (state.errorMessage.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errorMessage)),
                  );
                }
                if (!state.isSubmitting && state.errorMessage.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password reset successful!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Navigate to LoginScreen after successful password reset
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo
                    Image.asset(
                      'assets/images/logo_white.png',
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 54),

                    // New Password Field
                    TextField(
                      controller: _newPasswordController,
                      obscureText: state.obscureNewPassword,
                      onChanged: (value) => context
                          .read<ResetPasswordBloc>()
                          .add(NewPasswordChanged(value)),
                      decoration: InputDecoration(
                        labelText: 'Шинэ нууц үг',
                        suffixIcon: IconButton(
                          icon: Icon(state.obscureNewPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            context
                                .read<ResetPasswordBloc>()
                                .add(ToggleNewPasswordVisibility());
                          },
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password Field
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: state.obscureConfirmPassword,
                      onChanged: (value) => context
                          .read<ResetPasswordBloc>()
                          .add(ConfirmPasswordChanged(value)),
                      decoration: InputDecoration(
                        labelText: 'Нууц үг баталгаажуулах',
                        suffixIcon: IconButton(
                          icon: Icon(state.obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            context
                                .read<ResetPasswordBloc>()
                                .add(ToggleConfirmPasswordVisibility());
                          },
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Reset Password Button
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<ResetPasswordBloc>()
                            .add(SubmitResetPassword());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.black, // Text color
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: state.isSubmitting
                          ? const CircularProgressIndicator()
                          : Text('Нууц үг шинэчлэх',
                              style: theme.textTheme.bodyLarge),
                    ),
                    const SizedBox(height: 16),

                    // Cancel Button
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        side: const BorderSide(color: Colors.black),
                      ),
                      child: const Text('Cancel',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
