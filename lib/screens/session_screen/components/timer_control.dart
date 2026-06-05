import 'dart:async';

import 'package:beatlio_v2/provider/session_provider.dart';
import 'package:beatlio_v2/ui/theme/custom_colors.dart';
import 'package:beatlio_v2/utilities/text_formatters/time_formatter.dart';
import 'package:flutter/material.dart' show CircularProgressIndicator;
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart'
    hide CircularProgressIndicator;

class TimerControl extends StatefulWidget {
  final bool isRest;
  final Function()? onComplete;
  final Function()? onStart;
  final int initialTimeSeconds;
  final String? label;

  const TimerControl({
    super.key,
    required this.isRest,
    this.onComplete,
    this.onStart,
    required this.initialTimeSeconds,
    this.label,
  });

  @override
  State<TimerControl> createState() => _TimerControlState();
}

class _TimerControlState extends State<TimerControl>
    with SingleTickerProviderStateMixin {
  static const Duration _tickDuration = Duration(milliseconds: 100);
  static const Color _warningColor = CustomColors.red;

  late int remainingMilliseconds;

  Timer? _timer;
  bool? _lastPlayingState;

  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    remainingMilliseconds = widget.initialTimeSeconds * 1000;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _syncPulseState();

    _startTimer();
  }

  void _syncPulseState() {
    final shouldPulse =
        remainingMilliseconds > 0 && remainingMilliseconds <= 3000;

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

  void _startTimer() {
    if (_timer?.isActive ?? false) return;

    widget.onStart?.call();

    _timer = Timer.periodic(_tickDuration, (timer) {
      final nextRemaining =
          remainingMilliseconds - _tickDuration.inMilliseconds;

      if (nextRemaining > 0) {
        setState(() {
          remainingMilliseconds = nextRemaining;
          _syncPulseState();
        });
        return;
      }

      timer.cancel();
      _timer = null;

      setState(() {
        remainingMilliseconds = 0;
        _syncPulseState();
      });

      widget.onComplete?.call();
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final progress =
        (widget.initialTimeSeconds * 1000 - remainingMilliseconds) /
        (widget.initialTimeSeconds * 1000);

    final remainingSeconds = (remainingMilliseconds / 1000).ceil();

    final pulseActive =
        remainingMilliseconds > 0 && remainingMilliseconds <= 3000;

    return Selector<SessionProvider, bool>(
      selector: (_, provider) => provider.isSessionPlaying,
      builder: (context, isPlaying, child) {
        if (_lastPlayingState != isPlaying) {
          _lastPlayingState = isPlaying;

          if (isPlaying) {
            _startTimer();
          } else {
            _pauseTimer();
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
                    minWidth: 250,
                    minHeight: 250,
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
                final pulseValue = pulseActive ? _pulseController.value : 0.0;

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
