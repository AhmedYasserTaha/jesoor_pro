import 'package:flutter/material.dart';

class ConfirmPhoneDialog extends StatelessWidget {
  final String email;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmPhoneDialog({
    super.key,
    required this.email,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Phone Number'),
      content: Text(
        'We will send an OTP code to $email.\nIs this correct?',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onCancel();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }

  static void show({
    required BuildContext context,
    required String email,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) {
    showDialog(
      context: context,
      builder: (context) => ConfirmPhoneDialog(
        email: email,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }
}
