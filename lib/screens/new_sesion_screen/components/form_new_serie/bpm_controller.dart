import 'package:shadcn_flutter/shadcn_flutter.dart';

class BPMController extends StatefulWidget {
  final int? initBPM;
  final Function(int)? onBPMChanged;
  final Function(bool)? onBPMEnabledChanged;
  final bool bpmEnabled;
  const BPMController({
    super.key,
    this.initBPM,
    this.onBPMChanged,
    this.onBPMEnabledChanged,
    this.bpmEnabled = true,
  });

  @override
  State<BPMController> createState() => _BPMControllerState();
}

class _BPMControllerState extends State<BPMController> {
  final TextEditingController bpmTextController = TextEditingController();
  FocusNode bpmFocusNode = FocusNode();
  bool switchEnabled = true;
  bool firstTime = true;

  @override
  void initState() {
    super.initState();

    switchEnabled = widget.bpmEnabled;
    bpmTextController.text = widget.initBPM?.toString() ?? "120";

    bpmFocusNode.addListener(() {
      if (!bpmFocusNode.hasFocus) {
        setBPM(bpmTextController.text);
      }
    });

    firstTime = false;
  }

  @override
  void dispose() {
    bpmTextController.dispose();
    bpmFocusNode.dispose();
    super.dispose();
  }

  int? getNumericValue(String text) {
    final numericString = text.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(numericString);
  }

  void setBPM(String text) {
    if (firstTime) return;
    final numericValue = getNumericValue(text) ?? 120;

    final bpmValue = numberToBPM(numericValue);

    bpmTextController.text = bpmValue.toString();

    if (widget.onBPMChanged != null) {
      widget.onBPMChanged!(bpmValue);
    }
  }

  int numberToBPM(int number) {
    if (number < 40) return 40;
    if (number > 240) return 240;
    return number;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Switch(
              value: switchEnabled,
              onChanged: (value) {
                setState(() {
                  switchEnabled = value;
                });
                widget.onBPMEnabledChanged?.call(value);
              },
            ),
            const Gap(10),
            Text("BPM Global").xSmall(),
          ],
        ),
        Gap(15),
        SizedBox(
          width: 70,
          child: TextField(
            placeholder: Text("120").xSmall(),
            maxLength: 3,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            controller: bpmTextController,
            enabled: switchEnabled,
            focusNode: bpmFocusNode,
            onTapOutside: (event) {
              setBPM(bpmTextController.text);
              bpmFocusNode.unfocus();
            },
            onSubmitted: (value) {
              setBPM(value);
              bpmFocusNode.unfocus();
            },
          ),
        ),
      ],
    );
  }
}
