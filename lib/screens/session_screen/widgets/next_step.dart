import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:beatlio_v2/models/session_step.dart';
import 'package:beatlio_v2/utilities/text_formatters/time_formatter.dart';

class NextStep extends StatelessWidget {
  final SessionStep? nextExercise;
  const NextStep({super.key, required this.nextExercise});

  @override
  Widget build(BuildContext context) {
    final label = nextExercise == null
        ? 'Fin de sesión'
        : nextExercise!.isRest
        ? 'Descanso • ${formatDuration(nextExercise!.duration)}'
        : nextExercise!.name;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Siguiente:",
        ).xSmall(color: Colors.white.withValues(alpha: 0.8)).medium(),

        const Gap(10),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            final offsetAnimation = Tween<Offset>(
              begin: const Offset(0.0, 0.15),
              end: Offset.zero,
            ).animate(animation);

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: offsetAnimation, child: child),
            );
          },
          child: Text(label, key: ValueKey(label)).muted().xSmall().medium(),
        ),
      ],
    );
  }
}
