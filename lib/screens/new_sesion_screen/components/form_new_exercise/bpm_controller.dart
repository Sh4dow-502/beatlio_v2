import 'package:beatlio_v2/screens/new_sesion_screen/widgets/custom_badge.dart';
import 'package:beatlio_v2/screens/new_sesion_screen/widgets/custom_button.dart';
import 'package:beatlio_v2/ui/components/custom_gradient_slider.dart';
import 'package:beatlio_v2/ui/theme/custom_colors.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class BPMController extends StatefulWidget {
  final int? initialBPM;

  final Function(int)? onBPMChanged;
  const BPMController({super.key, this.initialBPM, this.onBPMChanged});

  @override
  State<BPMController> createState() => _BPMControllerState();
}

class _BPMControllerState extends State<BPMController> {
  SliderValue valueBPM = const SliderValue.single(120);
  final TextEditingController bpmController = TextEditingController();
  final FocusNode bpmFocusNode = FocusNode();
  bool enabledField = false;

  int value = 120;

  @override
  void initState() {
    super.initState();

    widget.initialBPM != null
        ? bpmController.text = "${widget.initialBPM} BPM"
        : bpmController.text = "120 BPM";
    widget.initialBPM != null
        ? valueBPM = SliderValue.single(widget.initialBPM!.toDouble())
        : valueBPM = const SliderValue.single(120);

    widget.initialBPM != null ? value = widget.initialBPM! : value = 120;
  }

  @override
  void dispose() {
    bpmController.dispose();
    bpmFocusNode.dispose();
    super.dispose();
  }

  void setBpm(double value) {
    this.value = value.toInt();
    valueBPM = SliderValue.single(value);
    formatBPM(value.toInt());
    setState(() {});

    if (widget.onBPMChanged != null) {
      widget.onBPMChanged!(value.toInt());
    }
  }

  int? getNumericValue(String text) {
    final numericString = text.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(numericString);
  }

  String formatBPM(int bpm) {
    if (bpm < 40) bpm = 40;
    if (bpm > 240) bpm = 240;

    bpmController.text = "$bpm BPM";
    valueBPM = SliderValue.single(bpm.toDouble());
    return "$bpm BPM";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              CustomBadge(
                text: "60 BPM",
                onTap: () => setBpm(60),
                selected: value == 60,
              ),
              CustomBadge(
                text: "80 BPM",
                onTap: () => setBpm(80),
                selected: value == 80,
              ),
              CustomBadge(
                text: "90 BPM",
                onTap: () => setBpm(90),
                selected: value == 90,
              ),
              CustomBadge(
                text: "120 BPM",
                onTap: () => setBpm(120),
                selected: value == 120,
              ),
            ],
          ),
          const Gap(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomButton(
                onPressed: () => setBpm(valueBPM.value - 10),
                text: "-10",
              ),
              const Gap(10),
              CustomButton(
                onPressed: () => setBpm(valueBPM.value - 1),
                text: "-1",
              ),
              const Gap(20),
              SizedBox(
                width: 90,
                child: TextField(
                  autofocus: enabledField,
                  controller: bpmController,
                  focusNode: bpmFocusNode,
                  onSubmitted: (value) {
                    setBpm(
                      getNumericValue(value)?.toDouble() ?? valueBPM.value,
                    );
                    bpmFocusNode.unfocus();
                    setState(() {
                      enabledField = false;
                    });
                  },
                  onTapOutside: (event) {
                    setBpm(
                      getNumericValue(bpmController.text)?.toDouble() ??
                          valueBPM.value,
                    );
                    bpmFocusNode.unfocus();
                    setState(() {
                      enabledField = false;
                    });
                  },
                  decoration: enabledField
                      ? null
                      : BoxDecoration(
                          border: Border.all(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(18),
                        ),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  onTap: () {
                    setState(() {
                      enabledField = true;
                    });
                  },
                ),
              ),
              const Gap(20),
              CustomButton(
                onPressed: () => setBpm(valueBPM.value + 1),
                text: "+1",
              ),
              const Gap(10),
              CustomButton(
                onPressed: () => setBpm(valueBPM.value + 10),
                text: "+10",
              ),
            ],
          ),
          const Gap(10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomGradientSlider(
              gradientColors: [
                // CustomColors.celeste,
                CustomColors.lightPurple,
                CustomColors.lightPurple,
                // CustomColors.morado,
              ],
              value: valueBPM.value,
              min: 40,
              max: 240,
              onChanged: (value) => setBpm(value),
            ),
          ),
        ],
      ),
    );
  }
}
