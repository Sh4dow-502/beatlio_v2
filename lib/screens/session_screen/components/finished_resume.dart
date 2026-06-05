import 'package:beatlio_v2/provider/metronome_global_provider.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class FinishedResume extends StatefulWidget {
  const FinishedResume({super.key});

  @override
  State<FinishedResume> createState() => _FinishedResumeState();
}

class _FinishedResumeState extends State<FinishedResume> {
  @override
  void initState() {
    super.initState();
    context.read<MetronomeGlobalProvider>().stopFinishedClick();
    context.read<MetronomeGlobalProvider>().playEndSessionSound();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [Text("¡Sesión Completada!").xLarge().bold()]);
  }
}
