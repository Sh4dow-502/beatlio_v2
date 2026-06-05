import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return shadcn.AlertDialog(
      title: const shadcn.Text('Eliminar').small(),
      content: const shadcn.Text('¿Deseas eliminar este elemento?').small(),
      actions: [
        shadcn.OutlineButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const shadcn.Text('Cancel').xSmall(),
        ),
        shadcn.PrimaryButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const shadcn.Text('Eliminar').xSmall(),
        ),
      ],
    );
  }
}
