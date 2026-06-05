import 'package:beatlio_v2/provider/metronome_provider.dart';
import 'package:beatlio_v2/ui/components/custom_gradient_slider.dart';
import 'package:beatlio_v2/ui/theme/custom_colors.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ControllerBPM extends StatelessWidget {
  const ControllerBPM({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      borderRadius: BorderRadius.circular(18),
      borderColor: Colors.transparent,
      child: Column(
        children: [
          Row(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _ShortcutBadge(label: 'Lento', bpmValue: 60),
              _ShortcutBadge(label: 'Moderado', bpmValue: 120),
              _ShortcutBadge(label: 'Rapido', bpmValue: 180),
            ],
          ),
        ],
      ),
    );
  }
}

class SliderControl extends StatefulWidget {
  const SliderControl({super.key});

  @override
  State<SliderControl> createState() => _SliderControlState();
}

class _SliderControlState extends State<SliderControl> {
  int value = MetronomeProvider.minBpm;
  @override
  Widget build(BuildContext context) {
    return Consumer<MetronomeProvider>(
      builder: (context, metronomeProvider, child) {
        value = metronomeProvider.bpm;
        return Column(
          children: [
            CustomGradientSlider(
              gradientColors: [
                CustomColors.purple,
                CustomColors.secondaryTag,
                CustomColors.lightPink,
              ],
              value: value.toDouble(),
              min: MetronomeProvider.minBpm.toDouble(),
              max: MetronomeProvider.maxBpm.toDouble(),
              divisions: MetronomeProvider.maxBpm - MetronomeProvider.minBpm,
              onChanged: (p0) {
                setState(() {
                  value = p0.toInt();
                });
                metronomeProvider.setBpm(value);
              },
            ),
            const Gap(1),
            Row(
              children: [
                Text("${MetronomeProvider.minBpm}").xSmall().muted(),
                const Spacer(),
                Text("${MetronomeProvider.maxBpm}").xSmall().muted(),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ShortcutBadge extends StatelessWidget {
  final String label;
  final int bpmValue;
  const _ShortcutBadge({required this.label, required this.bpmValue});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Consumer<MetronomeProvider>(
      builder: (context, metronomeProvider, child) {
        final isSelected = metronomeProvider.bpm == bpmValue;
        return GestureDetector(
          onTap: () {
            HapticFeedback.heavyImpact();
            metronomeProvider.setBpm(bpmValue);
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? colors.secondary : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected
                    ? colors.secondary
                    : Colors.white.withValues(alpha: 0.2),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
            child: Column(
              children: [
                isSelected
                    ? Text(label).xSmall().light()
                    : Text(label).xSmall().muted().light(),

                const Gap(5),
                Text("$bpmValue BPM").xSmall().medium(),
              ],
            ),
          ),
        );
      },
    );
  }
}
