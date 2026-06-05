import 'dart:async';

import 'package:beatlio_v2/provider/metronome_provider.dart';
import 'package:beatlio_v2/provider/session_provider.dart';
import 'package:beatlio_v2/ui/theme/custom_colors.dart';
import 'package:beatlio_v2/utilities/text_formatters/time_formatter.dart';
import 'package:flutter/material.dart' show CircularProgressIndicator;
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart'
    hide CircularProgressIndicator;

class TimeCircularProgress extends StatefulWidget {
  final int initialTimeSeconds;
  final String? label;
  final bool pauseAfter;
  final bool playAfter;
  final bool isRest;

  const TimeCircularProgress({
    super.key,
    required this.initialTimeSeconds,
    this.label,
    this.pauseAfter = false,
    this.playAfter = false,
    this.isRest = false,
  });

  @override
  State<TimeCircularProgress> createState() => _TimeCircularProgressState();
}

class _TimeCircularProgressState extends State<TimeCircularProgress>
    with SingleTickerProviderStateMixin {
  static const Color _warningColor = CustomColors.red;
  static const Duration _tickDuration = Duration(milliseconds: 100);

  late int initialTimeSeconds;
  late int remainingTimeMilliseconds;

  Timer? _timer;
  bool? _lastPlayingState;
  bool _restSoundPlayed = false;

  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    print("INIT ${widget.label} REST=${widget.isRest}");

    initialTimeSeconds = widget.initialTimeSeconds;
    remainingTimeMilliseconds = widget.initialTimeSeconds * 1000;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _syncPulseState();
  }

  void _syncPulseState() {
    final shouldPulse =
        remainingTimeMilliseconds > 0 && remainingTimeMilliseconds <= 3000;

    if (shouldPulse) {
      if (!_pulseController.isAnimating) {
        _pulseController.repeat(reverse: true);
      }
      return;
    }

    if (_pulseController.isAnimating) {
      _pulseController.stop();
    }

    _pulseController.value = 0;
  }

  void startTimer() {
    print(
      "START TIMER rest=${widget.isRest} "
      "pauseAfter=${widget.pauseAfter} "
      "playAfter=${widget.playAfter}",
    );
    if (_timer?.isActive ?? false) return;

    if (widget.isRest && !_restSoundPlayed) {
      context.read<MetronomeProvider>().playRestSound();
      _restSoundPlayed = true;
    }

    _timer = Timer.periodic(_tickDuration, (timer) {
      final nextRemaining =
          remainingTimeMilliseconds - _tickDuration.inMilliseconds;

      if (nextRemaining > 0) {
        setState(() {
          remainingTimeMilliseconds = nextRemaining;
          _syncPulseState();
        });
        return;
      }

      timer.cancel();
      _timer = null;

      setState(() {
        remainingTimeMilliseconds = 0;
        _syncPulseState();
      });

      context.read<SessionProvider>().advanceOneStep();

      if (widget.pauseAfter) {
        context.read<MetronomeProvider>().stopClick();
      }

      if (widget.playAfter) {
        context.read<MetronomeProvider>().playClick();
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void didUpdateWidget(TimeCircularProgress oldWidget) {
    super.didUpdateWidget(oldWidget);

    print("UPDATE old=${oldWidget.isRest} new=${widget.isRest}");
  }

  @override
  void dispose() {
    print("DISPOSE ${widget.label}");
    pauseTimer();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final progress = initialTimeSeconds <= 0
        ? 1.0
        : (initialTimeSeconds * 1000 - remainingTimeMilliseconds) /
              (initialTimeSeconds * 1000);

    final pulseActive =
        remainingTimeMilliseconds > 0 && remainingTimeMilliseconds <= 3000;

    final remainingSeconds = (remainingTimeMilliseconds / 1000).ceil();

    return Consumer<SessionProvider>(
      builder: (context, session, child) {
        if (_lastPlayingState != session.isSessionPlaying) {
          _lastPlayingState = session.isSessionPlaying;

          if (session.isSessionPlaying) {
            startTimer();
          } else {
            pauseTimer();
          }
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress.clamp(0, 1)),
              duration: const Duration(milliseconds: 380),
              curve: Curves.easeOutCubic,
              builder: (context, animatedProgress, _) {
                return CircularProgressIndicator(
                  backgroundColor:
                      (widget.isRest
                              ? CustomColors.greenCircularProgress
                              : colors.primary)
                          .withValues(alpha: 0.17),
                  value: animatedProgress,
                  color: widget.isRest
                      ? CustomColors.greenCircularProgress
                      : pulseActive
                      ? _warningColor
                      : colors.primary,
                  strokeWidth: 18,
                  constraints: const BoxConstraints(
                    minHeight: 250,
                    minWidth: 250,
                  ),
                  trackGap: 10,
                  padding: const EdgeInsets.all(20),
                  strokeCap: StrokeCap.round,
                );
              },
            ),
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final pulseValue = pulseActive ? _pulseController.value : 0;

                final scale = pulseActive ? 1 + (pulseValue * 0.08) : 1.0;

                final textColor = pulseActive
                    ? Color.lerp(
                        Colors.white,
                        _warningColor,
                        pulseValue.toDouble(),
                      )!
                    : Colors.white;

                return Transform.scale(
                  scale: scale,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        formatSeconds(remainingSeconds),
                      ).x5Large().black(color: textColor),

                      if (widget.label != null) ...[
                        const Gap(6),
                        Text(widget.label!).small().muted(),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
