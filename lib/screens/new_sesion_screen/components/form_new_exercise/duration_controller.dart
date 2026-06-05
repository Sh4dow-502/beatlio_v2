import 'package:beatlio_v2/screens/new_sesion_screen/widgets/custom_badge.dart';
import 'package:beatlio_v2/ui/components/custom_gradient_slider.dart';
import 'package:beatlio_v2/ui/theme/custom_colors.dart';
import 'package:beatlio_v2/utilities/text_formatters/time_formatter.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class DurationController extends StatefulWidget {
  final Function(int)? onDurationChanged;
  final int? initialDuration;
  const DurationController({
    super.key,
    this.onDurationChanged,
    this.initialDuration,
  });

  @override
  State<DurationController> createState() => _DurationControllerState();
}

class _DurationControllerState extends State<DurationController> {
  int value = 60;

  bool firstTime = true;

  @override
  void initState() {
    super.initState();

    widget.initialDuration != null
        ? setDuration(widget.initialDuration!)
        : setDuration(60);

    firstTime = false;
  }

  void setDuration(int value) {
    this.value = value;
    if (firstTime) return;
    if (widget.onDurationChanged != null) {
      widget.onDurationChanged!(value);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          const Gap(10),
          Wrap(
            spacing: 15,
            runSpacing: 15,
            children: [
              CustomBadge(
                text: "1 min",
                selected: value == 60,
                onTap: () => setDuration(60),
              ),
              CustomBadge(
                text: "3 min",
                selected: value == 180,
                onTap: () => setDuration(3 * 60),
              ),
              CustomBadge(
                text: "5 min",
                selected: value == 300,
                onTap: () => setDuration(5 * 60),
              ),
              CustomBadge(
                text: "15 min",
                selected: value == 600,
                onTap: () => setDuration(15 * 60),
              ),
            ],
          ),
          const Gap(15),
          Column(
            children: [
              const Gap(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Duracion: ${formatDuration(value)}",
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
              const Gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomGradientSlider(
                  gradientColors: [
                    // CustomColors.morado,
                    // CustomColors.purple,
                    // CustomColors.celeste,
                    CustomColors.lightPurple,
                    CustomColors.lightPurple,
                  ],
                  value: value.toDouble(),
                  min: 60,
                  max: 3600,
                  divisions: 59,
                  onChanged: (p0) => setDuration(p0.toInt()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
