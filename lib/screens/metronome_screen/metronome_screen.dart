import 'package:beatlio_v2/screens/metronome_screen/components/bpm_indicators.dart';
import 'package:beatlio_v2/screens/metronome_screen/components/control_play.dart';
import 'package:beatlio_v2/screens/metronome_screen/components/controller_general.dart';
import 'package:beatlio_v2/screens/metronome_screen/widgets/bpm_controls.dart';
import 'package:beatlio_v2/screens/metronome_screen/widgets/text_bpm.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class MetronomeScreen extends StatelessWidget {
  const MetronomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        headers: [AppBar(title: const Text('Metrónomo').xLarge().bold())],
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              BpmIndicators(),
              const Gap(20),
              TextBPM(),
              const Gap(20),
              BpmControls(),
              const Gap(50),
              ControllerGeneral(),
              Spacer(),
              ControlPlay(),
              const Gap(120),
            ],
          ),
        ),
      ),
    );
  }
}
