import 'package:beatlio_v2/provider/metronome_global_provider.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class BpmControls extends StatelessWidget {
  const BpmControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MetronomeGlobalProvider>(
      builder: (context, metronomeProvider, child) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.46),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Button.secondary(
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    metronomeProvider.setBpm(metronomeProvider.bpm - 10);
                  },
                  style: ButtonStyle(variance: ButtonStyle.secondary()),
                  child: Text('-10').xSmall().semiBold(),
                ),
                const Gap(8),
                Button.secondary(
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    metronomeProvider.setBpm(metronomeProvider.bpm - 1);
                  },
                  style: ButtonStyle(variance: ButtonStyle.secondary()),
                  child: Text('-1').xSmall().semiBold(),
                ),
                const Gap(20),
                Container(
                  width: 1,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const Gap(20),
                Button.secondary(
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    metronomeProvider.setBpm(metronomeProvider.bpm + 1);
                  },
                  style: ButtonStyle(variance: ButtonStyle.secondary()),
                  child: Text('+1').xSmall().semiBold(),
                ),
                const Gap(8),
                Button.secondary(
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    metronomeProvider.setBpm(metronomeProvider.bpm + 10);
                  },
                  style: ButtonStyle(variance: ButtonStyle.secondary()),
                  child: Text('+10').xSmall().semiBold(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
