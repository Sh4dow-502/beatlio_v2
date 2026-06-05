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
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: colors.primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              metronomeProvider.isPlaying
                  ? BootstrapIcons.pause
                  : BootstrapIcons.play,
              color: Colors.white,
              size: 45,
            ),
          ),
        );
      },
    );
  }
}
