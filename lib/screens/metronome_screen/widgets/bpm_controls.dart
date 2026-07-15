import 'package:beatlio_v2/provider/metronome_global_provider.dart';
import 'package:beatlio_v2/ui/theme/custom_colors.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class BpmControls extends StatelessWidget {
  const BpmControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MetronomeGlobalProvider>(
      builder: (context, metronomeProvider, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButtonControl(
              label: 'Lento',
              bpm: '60 BPM',
              onTap: () {
                HapticFeedback.heavyImpact();
                metronomeProvider.setBpm(60);
              },
            ),
            const Gap(20),
            CustomButtonControl(
              label: 'Moderado',
              bpm: '120 BPM',
              onTap: () {
                HapticFeedback.heavyImpact();
                metronomeProvider.setBpm(120);
              },
            ),
            const Gap(20),
            CustomButtonControl(
              label: 'Rápido',
              bpm: '180 BPM',
              onTap: () {
                HapticFeedback.heavyImpact();
                metronomeProvider.setBpm(180);
              },
            ),
          ],
        );
      },
    );
  }
}

class CustomButtonControl extends StatelessWidget {
  final String label;
  final String bpm;
  final Function()? onTap;
  const CustomButtonControl({
    super.key,
    this.label = "Lento",
    this.bpm = "60 BPM",
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.containerColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(
          children: [
            Text(label).xSmall(),
            const Gap(4),
            Text(bpm).xSmall().medium(color: colors.primary),
          ],
        ),
      ),
    );
  }
}
