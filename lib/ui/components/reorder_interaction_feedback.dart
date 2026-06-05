import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReorderInteractionFeedback extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const ReorderInteractionFeedback({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  State<ReorderInteractionFeedback> createState() =>
      _ReorderInteractionFeedbackState();
}

class _ReorderInteractionFeedbackState
    extends State<ReorderInteractionFeedback> {
  bool pressed = false;

  void _setPressed(bool value) {
    if (pressed == value) return;
    setState(() {
      pressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: widget.enabled
          ? (_) {
              _setPressed(true);
              HapticFeedback.mediumImpact();
              SystemSound.play(SystemSoundType.click);
            }
          : null,
      onPointerUp: widget.enabled ? (_) => _setPressed(false) : null,
      onPointerCancel: widget.enabled ? (_) => _setPressed(false) : null,
      child: AnimatedScale(
        scale: pressed ? 0.985 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
