import 'package:flutter/material.dart';
import 'package:jesoor_pro/core/utils/strings.dart';

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
      title: const Text(Strings.confirmPhoneNumber),
      content: Text(
        Strings.replacePlaceholder(Strings.confirmPhoneMessage, 'phone', email),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onCancel();
          },
          child: const Text(Strings.cancel),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: const Text(Strings.confirm),
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
