import 'package:beatlio_v2/provider/metronome_global_provider.dart';
import 'package:beatlio_v2/provider/session_provider.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ButtonPrevious extends StatelessWidget {
  const ButtonPrevious({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionProvider>(
      builder: (context, sessionProvider, child) {
        final canGoPrevious = sessionProvider.canGoPreviousStep;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: canGoPrevious
              ? () {
                  HapticFeedback.lightImpact();
                  sessionProvider.goToPreviousStep();

                  final current = sessionProvider.currentExercise;

                  if (current?.isRest ?? false) {
                    context.read<MetronomeGlobalProvider>().stopClick();
                  } else {
                    if (sessionProvider.isSessionPlaying) {
                      context.read<MetronomeGlobalProvider>().playClick();
                    } else {
                      context.read<MetronomeGlobalProvider>().stopClick();
                    }
                    // metronomeProvider.restart();
                  }

                  // final metronomeProvider = context.read<MetronomeProvider>();
                  // if (sessionProvider.isSessionPlaying) {
                  //   metronomeProvider.restart();
                  // } else {
                  //   metronomeProvider.stop();
                  // }
                }
              : null,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.secondary.withValues(
                alpha: canGoPrevious ? 0.75 : 0.35,
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Icon(
              RadixIcons.trackPrevious,
              color: Colors.white.withValues(
                alpha: canGoPrevious ? 0.85 : 0.55,
              ),
            ),
          ),
        );
      },
    );
  }
}
