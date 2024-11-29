import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_police/screens/login_screen/login_bloc.dart';
import 'package:school_police/screens/signup_screen/signup_screen.dart';
import 'package:school_police/widgets/forgot_password_dialog.dart';
import '../home_screen/home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    // Get the theme data from context
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/logo.png',
                height: 80,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 96),
              TextField(
                controller: emailController,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  labelText: 'Имэйл эсвэл нэвтрэх нэр',
                  labelStyle: theme.textTheme.bodyLarge,
                  fillColor: null,
                  filled: false,
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  bool obscurePassword = true;
                  if (state is ObscurePasswordState) {
                    obscurePassword = state.obscurePassword;
                  }

                  return TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Нууц үг',
                      labelStyle: theme.textTheme.bodyLarge,
                      fillColor: null,
                      filled: false,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          loginBloc.add(
                            TogglePasswordVisibility(
                                obscurePassword: obscurePassword),
                          );
                        },
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is LoginSuccess) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => HomeScreen()),
                    );
                  } else if (state is LoginFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            loginBloc.add(Check(
                              username: emailController.text,
                              password: passwordController.text,
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.secondary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Нэвтрэх'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'эсвэл',
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              // Add Facebook login logic
                            },
                            icon:
                                const Icon(Icons.facebook, color: Colors.blue),
                            label: const Text('Facebook'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Add Google login logic
                            },
                            icon: const Icon(Icons.g_mobiledata,
                                color: Colors.red),
                            label: const Text('Google'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Forgot password gesture
                      GestureDetector(
                        onTap: () {
                          _showForgotPasswordDialog(
                              context); // Call the dialog method
                        },
                        child: Text('Нууц үг мартсан?',
                            style: theme.textTheme.bodyLarge),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupScreen()),
                          );
                        },
                        child: Text(
                          'Бүртгэлгүй юу? Шинээр бүртгүүлэх',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showForgotPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ForgotPasswordDialog(); // Display the ForgotPasswordDialog widget
      },
    );
  }
}
