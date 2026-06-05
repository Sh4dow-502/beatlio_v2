import 'package:beatlio_v2/provider/metronome_global_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonMutted extends StatelessWidget {
  const ButtonMutted({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Consumer(
      builder: (context, MetronomeGlobalProvider metronomeProvider, child) {
        final isMutted = metronomeProvider.isMuted;

        return GestureDetector(
          onTap: () {
            metronomeProvider.toggleMute();
          },
          child: Container(
            decoration: BoxDecoration(
              color: isMutted
                  ? Colors.transparent
                  : colors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: isMutted ? colors.secondary : colors.primary,
              ),
            ),
            padding: const EdgeInsets.all(15),
            child: Icon(
              CupertinoIcons.metronome,
              color: isMutted
                  ? Colors.white.withValues(alpha: 0.5)
                  : colors.primary,
            ),
          ),
        );
      },
    );
  }
}
