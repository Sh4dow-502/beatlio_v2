import 'package:beatlio_v2/models/acent_type.dart';
import 'package:beatlio_v2/provider/metronome_global_provider.dart';
import 'package:beatlio_v2/screens/metronome_screen/components/dot_bpm.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class BpmIndicators extends StatelessWidget {
  const BpmIndicators({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<MetronomeGlobalProvider>();

    return Selector<
      MetronomeGlobalProvider,
      ({List<AccentType> pattern, bool isPlaying})
    >(
      selector: (_, p) => (pattern: p.accentPattern, isPlaying: p.isPlaying),
      builder: (context, data, child) {
        return ValueListenableBuilder<int>(
          valueListenable: provider.currentBeatNotifier,
          builder: (context, currentBeat, child) {
            return Wrap(
              runSpacing: 15,
              spacing: 20,
              alignment: WrapAlignment.center,
              children: List.generate(data.pattern.length, (index) {
                return DotBpm(
                  isAccentuated: data.pattern[index] == AccentType.accent,
                  isSelected: data.isPlaying && currentBeat == index,
                  onTap: () {
                    final current = data.pattern[index];

                    provider.setAccentAt(
                      index,
                      current == AccentType.accent
                          ? AccentType.normal
                          : AccentType.accent,
                    );
                  },
                );
              }),
            );
          },
        );
      },
    );
  }
}
