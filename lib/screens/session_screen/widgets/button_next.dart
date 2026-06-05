import 'package:beatlio_v2/provider/metronome_global_provider.dart';
import 'package:beatlio_v2/provider/session_provider.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ButtonNext extends StatelessWidget {
  const ButtonNext({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionProvider>(
      builder: (context, sessionProvider, child) {
        final canGoNext = sessionProvider.canGoNextStep;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: canGoNext
              ? () {
                  HapticFeedback.heavyImpact();
                  final nextExercise = sessionProvider.nextExercise;
                  if (nextExercise != null && nextExercise.isRest) {
                    context.read<MetronomeGlobalProvider>().stopClick();
                  } else {
                    if (sessionProvider.isSessionPlaying) {
                      context.read<MetronomeGlobalProvider>().playClick();
                    } else {
                      context.read<MetronomeGlobalProvider>().stopClick();
                    }
                  }
                  sessionProvider.goToNextStep();
                }
              : null,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.secondary.withValues(
                alpha: canGoNext ? 0.75 : 0.35,
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Icon(
              RadixIcons.trackNext,
              color: Colors.white.withValues(alpha: canGoNext ? 0.85 : 0.55),
            ),
          ),
        );
      },
    );
  }
}
