import 'package:beatlio_v2/models/session_step.dart';
import 'package:beatlio_v2/screens/session_screen/components/time_circular_progress.dart';
import 'package:beatlio_v2/screens/session_screen/widgets/next_step.dart';
import 'package:beatlio_v2/utilities/text_formatters/time_formatter.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class AnimatedSessionStep extends StatelessWidget {
  final SessionStep currentStep;
  final SessionStep? nextStep;

  const AnimatedSessionStep({
    super.key,
    required this.currentStep,
    required this.nextStep,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 380),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final scaleAnimation = Tween<double>(begin: 0.88, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        );

        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: scaleAnimation, child: child),
        );
      },
      child: _SessionStepContent(
        key: ValueKey(
          '${currentStep.isRest}-${currentStep.name}-${currentStep.duration}',
        ),
        currentStep: currentStep,
        nextStep: nextStep,
      ),
    );
  }
}

class _SessionStepContent extends StatelessWidget {
  final SessionStep currentStep;
  final SessionStep? nextStep;

  const _SessionStepContent({
    super.key,
    required this.currentStep,
    required this.nextStep,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NextStep(nextExercise: nextStep),
        const Gap(10),
        Text(currentStep.name).x3Large().bold(),
        const Gap(10),
        TimeCircularProgress(
          initialTimeSeconds: currentStep.duration,
          label: currentStep.isRest
              ? 'Descanso • ${formatDuration(currentStep.duration)}'
              : null,
          pauseAfter: currentStep.isRest,
          playAfter: !currentStep.isRest,
        ),
      ],
    );
  }
}
