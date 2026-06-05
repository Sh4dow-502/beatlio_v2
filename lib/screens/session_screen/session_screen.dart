import 'package:beatlio_v2/models/session.dart';
import 'package:beatlio_v2/provider/metronome_global_provider.dart';
import 'package:beatlio_v2/provider/session_provider.dart';
import 'package:beatlio_v2/screens/metronome_screen/components/bpm_indicators.dart';
import 'package:beatlio_v2/screens/session_screen/components/controls_media.dart';
import 'package:beatlio_v2/screens/session_screen/components/finished_resume.dart';
import 'package:beatlio_v2/screens/session_screen/components/timer_control.dart';
import 'package:beatlio_v2/screens/session_screen/widgets/animated_session_container.dart';
import 'package:beatlio_v2/screens/session_screen/widgets/button_compas.dart';
import 'package:beatlio_v2/screens/session_screen/widgets/button_mutted.dart';
import 'package:beatlio_v2/utilities/text_formatters/time_formatter.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class SessionScreen extends StatelessWidget {
  final Session session;
  const SessionScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        context.read<MetronomeGlobalProvider>().stopClick();
        context.read<SessionProvider>().pause();
        Navigator.pop(context);
      },
      child: SafeArea(
        child: Scaffold(
          headers: [
            AppBar(
              title: Text(
                session.name,
                overflow: TextOverflow.ellipsis,
              ).xLarge().bold(),
              leading: [
                OutlineButton(
                  density: ButtonDensity.icon,
                  onPressed: () {
                    context.read<MetronomeGlobalProvider>().stopClick();
                    context.read<SessionProvider>().pause();
                    Navigator.pop(context);
                  },
                  size: ButtonSize.small,
                  child: Icon(Icons.arrow_back),
                ),
              ],
              trailing: [
                IconButton(
                  icon: Icon(RadixIcons.reset),
                  variance: ButtonStyle.textIcon(),
                  onPressed: () {
                    context.read<MetronomeGlobalProvider>().stopClick();
                    context.read<SessionProvider>().resetSession();
                  },
                ),
              ],
              padding: EdgeInsets.all(10),
            ),
          ],
          child: Consumer<SessionProvider>(
            builder: (context, sessionProvider, child) {
              final currentStep = sessionProvider.currentExercise;

              final isRest = currentStep?.isRest ?? false;
              final animationKey = currentStep == null
                  ? 'completed'
                  : '${sessionProvider.currentExerciseIndex}-${currentStep.isRest}-${currentStep.name}-${currentStep.duration}';
              final content = sessionProvider.isSessionCompleted == true
                  ? FinishedResume()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          sessionProvider.progressText,
                        ).xSmall().muted().medium(),
                        const Gap(10),
                        BpmIndicators(),
                        const Gap(40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 5,
                          children: [
                            if (sessionProvider.nextExercise != null)
                              Text(
                                    "Siguiente:",
                                    textScaler: TextScaler.linear(0.95),
                                  )
                                  .xSmall(
                                    color: Colors.white.withValues(alpha: 0.85),
                                  )
                                  .medium(),
                            Text(
                              sessionProvider.nextExercise == null
                                  ? 'Fin de sesión'
                                  : sessionProvider.nextExercise!.isRest
                                  ? 'Descanso • ${formatDuration(sessionProvider.nextExercise!.duration)}'
                                  : "${sessionProvider.nextExercise!.name} • ${sessionProvider.nextExercise!.duration} BPM",

                              textScaler: TextScaler.linear(0.95),
                            ).xSmall().muted().medium(),
                          ],
                        ),

                        const Gap(10),
                        Text(currentStep!.name).x2Large().bold(),
                        const Gap(10),
                        TimerControl(
                          key: ValueKey(animationKey),
                          isRest: isRest,
                          initialTimeSeconds: currentStep.duration,
                          label: !currentStep.isRest
                              ? '${currentStep.bpm} BPM'
                              : null,

                          onStart: () {
                            context
                                .read<MetronomeGlobalProvider>()
                                .setBpmWithoutNotify(currentStep.bpm);
                            if (isRest) {
                              context
                                  .read<MetronomeGlobalProvider>()
                                  .stopClick();
                              context
                                  .read<MetronomeGlobalProvider>()
                                  .playRestSound();
                            }
                          },
                          onComplete: () {
                            HapticFeedback.heavyImpact();
                            final nextExercise = sessionProvider.nextExercise;
                            if (nextExercise != null && nextExercise.isRest) {
                              context
                                  .read<MetronomeGlobalProvider>()
                                  .stopClick();
                            } else {
                              if (sessionProvider.isSessionPlaying) {
                                context
                                    .read<MetronomeGlobalProvider>()
                                    .playClick();
                              } else {
                                context
                                    .read<MetronomeGlobalProvider>()
                                    .stopClick();
                              }
                            }
                            sessionProvider.advanceOneStep();
                          },
                          // pauseAfter:
                        ), // TimeCircularProgress(
                        //   key: ValueKey(animationKey),
                        //   initialTimeSeconds: currentStep.duration,
                        //   label: !currentStep.isRest
                        //       ? '${currentStep.duration} BPM'
                        //       : null,
                        //   pauseAfter:
                        //       sessionProvider.nextExercise != null &&
                        //           sessionProvider.nextExercise!.isRest ||
                        //       sessionProvider.nextExercise == null,
                        //   playAfter:
                        //       sessionProvider.nextExercise != null &&
                        //       !sessionProvider.nextExercise!.isRest,

                        //   isRest: isRest,
                        // ),
                        const Gap(20),
                        GeneralControls(),
                        const Gap(50),
                        ControlsMedia(),
                        const Gap(30),
                      ],
                    );

              return AnimatedSessionContainer(
                animationKey: animationKey,
                isRest: isRest,
                child: content,
              );
            },
          ),
        ),
      ),
    );
  }
}

class GeneralControls extends StatelessWidget {
  const GeneralControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [ButtonMutted(), const Gap(20), ButtonCompas()],
    );
  }
}
