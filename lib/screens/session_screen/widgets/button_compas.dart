import 'package:beatlio_v2/provider/metronome_provider.dart';
import 'package:beatlio_v2/screens/metronome_screen/components/form_compas.dart';
import 'package:beatlio_v2/ui/components/material_bottom_sheet.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ButtonCompas extends StatelessWidget {
  const ButtonCompas({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, MetronomeProvider metronomeProvider, child) {
        return GestureDetector(
          onTap: () {
            HapticFeedback.vibrate();
            openMaterialSheet(
              context: context,
              builder: (context) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 5,
                  ),
                  child: const FormCompas(),
                );
              },
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              shape: BoxShape.circle,
              // border: Border.all(color: Colors.white.withValues(alpha: 0.21)),
            ),
            padding: const EdgeInsets.all(21),
            child: Text(metronomeProvider.compasLabel).xSmall(),
          ),
        );
      },
    );
  }
}
