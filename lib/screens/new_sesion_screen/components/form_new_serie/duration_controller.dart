import 'package:shadcn_flutter/shadcn_flutter.dart';

class DurationController extends StatefulWidget {
  final int? initDuration;
  final Function(int)? onDurationChanged;
  final Function(bool)? onDurationEnabledChanged;
  final bool durationEnabled;

  const DurationController({
    super.key,
    this.initDuration,
    this.onDurationChanged,
    this.onDurationEnabledChanged,
    this.durationEnabled = true,
  });

  @override
  State<DurationController> createState() => _DurationControllerState();
}

class _DurationControllerState extends State<DurationController> {
  final TextEditingController durationTextController = TextEditingController();
  FocusNode durationFocusNode = FocusNode();
  bool switchEnabled = true;
  bool firstTime = true;

  @override
  void initState() {
    super.initState();

    switchEnabled = widget.durationEnabled;
    final initialSeconds = widget.initDuration ?? 60;
    durationTextController.text = (initialSeconds / 60).round().toString();

    durationFocusNode.addListener(() {
      if (!durationFocusNode.hasFocus) {
        setDuration(durationTextController.text);
      }
    });

    firstTime = false;
  }

  @override
  void dispose() {
    durationTextController.dispose();
    durationFocusNode.dispose();
    super.dispose();
  }

  int? getNumericValue(String text) {
    final numericString = text.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(numericString);
  }

  int numberToDuration(int number) {
    if (number < 1) return 1;
    if (number > 60) return 60;
    return number;
  }

  void setDuration(String text) {
    if (firstTime) return;

    final numericValue = getNumericValue(text) ?? 1;
    final durationMinutes = numberToDuration(numericValue);
    final durationValue = durationMinutes * 60;

    durationTextController.text = durationMinutes.toString();

    if (widget.onDurationChanged != null) {
      widget.onDurationChanged!(durationValue);
    }
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
                if (widget.onDurationEnabledChanged != null) {
                  widget.onDurationEnabledChanged!(value);
                }
              },
            ),
            const Gap(10),
            Text("Duración Global").xSmall(),
            const Gap(3),
            Text("(min)").xSmall().muted(),
          ],
        ),
        Gap(15),
        SizedBox(
          width: 70,
          child: TextField(
            placeholder: Text("1").xSmall(),
            maxLength: 2,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            controller: durationTextController,
            focusNode: durationFocusNode,
            onTapOutside: (event) {
              setDuration(durationTextController.text);
              durationFocusNode.unfocus();
            },
            onSubmitted: (value) {
              setDuration(value);
              durationFocusNode.unfocus();
            },
          ),
        ),
      ],
    );
  }
}
