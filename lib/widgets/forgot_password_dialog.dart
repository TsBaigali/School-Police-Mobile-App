import 'package:flutter/material.dart';
import 'package:school_police/screens/reset_password_screen/reset_password_screen.dart';

class ForgotPasswordDialog extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ForgotPasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Нууц үг сэргээх'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Бүртгэлтэй имэйл эсвэл утасны дугаараа доор оруулна уу. Бид танд нууц үг сэргээх линк илгээх болно.',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Имэйл эсвэл утас',
              labelStyle: TextStyle(color: Colors.black),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text(
            'CANCEL',
            style: TextStyle(color: Color(0xFF010536)),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ResetPasswordScreen()), // Navigate to ResetPasswordScreen
            );
          },
          child: const Text(
            'ИЛГЭЭХ',
            style: TextStyle(color: Color(0xFF010536)),
          ),
        ),
      ],
    );
  }
}
