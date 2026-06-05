import 'package:beatlio_v2/provider/metronome_global_provider.dart';
import 'package:beatlio_v2/screens/metronome_screen/components/form_compas.dart';
import 'package:beatlio_v2/screens/metronome_screen/widgets/button_general.dart';
import 'package:beatlio_v2/ui/components/material_bottom_sheet.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ControllerGeneral extends StatelessWidget {
  const ControllerGeneral({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MetronomeGlobalProvider>(
      builder: (context, metronomeProvider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonGeneral(
              child: Text(
                metronomeProvider.compasLabel,
                textScaler: TextScaler.linear(0.95),
              ).xSmall(),
              onPressed: () {
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
            ),
            const Gap(10),
            ButtonGeneral(
              child: Icon(LucideIcons.timer, size: 20),
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }
}
