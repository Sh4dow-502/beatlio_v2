import 'package:beatlio_v2/provider/metronome_global_provider.dart';
import 'package:beatlio_v2/provider/session_provider.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ButtonPlay extends StatelessWidget {
  const ButtonPlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionProvider>(
      builder: (context, sessionProvider, child) {
        final icon = sessionProvider.isSessionPlaying
            ? BootstrapIcons.pause
            : BootstrapIcons.play;
        return PrimaryButton(
          onPressed: () {
            HapticFeedback.heavyImpact();

            if (sessionProvider.currentExercise != null &&
                sessionProvider.currentExercise!.isRest) {
              context.read<MetronomeGlobalProvider>().stopClick();
            } else {
              context.read<MetronomeGlobalProvider>().togglePlaying();
            }
            sessionProvider.toggleSessionPlaying();
          },
          size: ButtonSize.large,
          density: ButtonDensity.icon,
          shape: ButtonShape.circle,
          child: Icon(icon, color: Colors.white),
        );
      },
    );
  }
}
