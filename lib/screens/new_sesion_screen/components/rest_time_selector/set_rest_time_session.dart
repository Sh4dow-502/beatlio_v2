import 'package:beatlio_v2/provider/new_session_provider.dart';
import 'package:beatlio_v2/utilities/text_formatters/time_formatter.dart';
import 'package:beatlio_v2/ui/components/material_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class RestTimeSelector extends StatelessWidget {
  const RestTimeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final restTime = context.watch<NewSessionProvider>().sessionRest;
    return Button.outline(
      leading: Icon(
        restTime > 0 ? LucideIcons.timer : LucideIcons.timerOff,
        size: 15,
      ),
      trailing: Icon(Icons.keyboard_arrow_down, size: 15),
      onPressed: () {
        openMaterialSheet(
          enableDrag: true,
          context: context,
          builder: (context) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 5,
              ),
              child: TimeSelector(restTime: restTime),
            );
          },
        );
      },
      enableFeedback: true,
      leadingGap: 3,
      style: ButtonStyle(variance: ButtonStyle.secondaryIcon()),
      child: Text(restTime > 0 ? formatDuration(restTime) : "").xSmall(),
    );
  }
}

class TimeSelector extends StatefulWidget {
  const TimeSelector({super.key, required this.restTime});

  final int restTime;

  @override
  State<TimeSelector> createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  final TextEditingController _controller = TextEditingController();
  int restTime = 10;

  @override
  void initState() {
    super.initState();

    _controller.text = "${widget.restTime}s";
    restTime = widget.restTime;
  }

  void _updateRestTime() {
    _controller.text = "${restTime}s";
    setState(() {});
  }

  void _onTextChanged(String value) {
    // print(value);
    final numericValue = int.tryParse(value.replaceAll('s', '')) ?? 0;

    if (numericValue < 0) {
      restTime = 0;
    } else if (numericValue > 300) {
      restTime = 300;
    } else {
      restTime = numericValue;
    }

    _updateRestTime();
  }

  int _parseRestTime(String value) {
    return int.tryParse(value.replaceAll('s', '')) ?? 0;
  }

  void _incrementRestTime() {
    if (restTime < 300) {
      restTime += 1;
      _updateRestTime();
    }
  }

  void _decrementRestTime() {
    if (restTime > 0) {
      restTime -= 1;
      _updateRestTime();
    }
  }

  void _setRestTime(int newTime) {
    if (newTime < 0) {
      newTime = 0;
    } else if (newTime > 300) {
      newTime = 300;
    }
    restTime = newTime;
    _updateRestTime();
  }

  void _saveRestTime() {
    context.read<NewSessionProvider>().setSessionRest(restTime);
    closeSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.timer, size: 20, color: colors.primary),
              const Gap(10),
              Text("Tiempo de descanso entre ejercicios").xSmall(),
            ],
          ),
          const Gap(30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Button.secondary(
                onPressed: () => _setRestTime(5),
                style: ButtonStyle(
                  variance: _parseRestTime(_controller.text) == 5
                      ? ButtonStyle.secondary()
                      : ButtonStyle.outline(),
                ),
                child: Text("5s").xSmall(),
              ),
              const Gap(15),
              Button.secondary(
                onPressed: () => _setRestTime(10),
                style: ButtonStyle(
                  variance: _parseRestTime(_controller.text) == 10
                      ? ButtonStyle.secondary()
                      : ButtonStyle.outline(),
                ),
                child: Text("10s").xSmall(),
              ),
              const Gap(15),
              Button.secondary(
                onPressed: () => _setRestTime(30),
                style: ButtonStyle(
                  variance: _parseRestTime(_controller.text) == 30
                      ? ButtonStyle.secondary()
                      : ButtonStyle.outline(),
                ),
                child: Text("30s").xSmall(),
              ),
            ],
          ),
          const Gap(30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.secondary(
                icon: Icon(LucideIcons.minus),
                onPressed: () => _decrementRestTime(),
              ),
              const Gap(10),
              SizedBox(
                width: 75,
                child: TextField(
                  controller: _controller,
                  maxLength: 3,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: (value) => _onTextChanged(value),
                ),
              ),
              const Gap(5),
              const Gap(10),
              IconButton.secondary(
                icon: Icon(LucideIcons.plus),
                onPressed: () => _incrementRestTime(),
              ),
            ],
          ),
          const Gap(40),
          PrimaryButton(
            child: Text("Guardar").xSmall(),
            onPressed: () => _saveRestTime(),
          ),
          const Gap(40),
        ],
      ),
    );
  }
}
