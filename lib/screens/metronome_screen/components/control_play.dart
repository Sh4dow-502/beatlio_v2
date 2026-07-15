import 'package:beatlio_v2/provider/metronome_global_provider.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ControlPlay extends StatelessWidget {
  const ControlPlay({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Consumer<MetronomeGlobalProvider>(
      builder: (context, metronomeProvider, child) {
        return GestureDetector(
          onTap: () {
            HapticFeedback.heavyImpact();
            metronomeProvider.togglePlaying();
          },
          child: Container(
            width: 300,
            // height: 100,
            decoration: BoxDecoration(
              color: metronomeProvider.isPlaying
                  ? colors.secondary.withValues(alpha: 0.5)
                  : colors.primary,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: metronomeProvider.isPlaying
                    ? colors.secondary
                    : colors.primary,
                width: 2,
              ),
              // shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  metronomeProvider.isPlaying
                      ? BootstrapIcons.pauseFill
                      : BootstrapIcons.playFill,
                  color: Colors.white,
                  size: 35,
                ),
                Text(
                  metronomeProvider.isPlaying ? "Detener" : "Iniciar",
                ).medium(),
              ],
            ),
          ),
        );
      },
    );
  }
}
