import 'package:flutter/material.dart';

Future<void> taskDialog({
  required BuildContext context,
  VoidCallback? onPressed,
  VoidCallback? onPressBack,
  Widget? content,
  String label = '',
  String onPressBackButtonLabel = '',
  bool barrierDismissible = true,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => AlertDialog(
      insetPadding: const EdgeInsets.all(12),
      actions: [
        TextButton(
          onPressed: onPressBack,
          child: const Text('Voltar'),
        ),
        Visibility(
          visible: label != '',
          child: TextButton(
            onPressed: onPressed,
            key: const Key('TapConfirm'),
            child: Text(label),
          ),
        ),
      ],
      content: content,
    ),
  );
}
