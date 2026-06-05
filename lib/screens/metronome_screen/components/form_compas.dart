import 'package:beatlio_v2/provider/metronome_global_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart'
    hide Colors, Column, Expanded, Positioned, Row, Stack;

class FormCompas extends StatefulWidget {
  const FormCompas({super.key});

  @override
  State<FormCompas> createState() => _FormCompasState();
}

class _FormCompasState extends State<FormCompas> {
  static const List<int> _numeratorOptions = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
  ];
  static const List<int> _denominatorOptions = [1, 2, 4, 8];

  late final FixedExtentScrollController _numeratorController;
  late final FixedExtentScrollController _denominatorController;
  bool _didInitialize = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInitialize) return;

    final metronomeProvider = context.read<MetronomeGlobalProvider>();
    final numeratorIndex = _indexForValue(
      _numeratorOptions,
      metronomeProvider.compasNumerator,
    );
    final denominatorIndex = _indexForValue(
      _denominatorOptions,
      metronomeProvider.compasDenominator,
    );

    _numeratorController = FixedExtentScrollController(
      initialItem: numeratorIndex,
    );
    _denominatorController = FixedExtentScrollController(
      initialItem: denominatorIndex,
    );
    _didInitialize = true;
  }

  int _indexForValue(List<int> options, int value) {
    final index = options.indexOf(value);
    if (index != -1) return index;

    return 0;
  }

  void _syncControllerToValue(
    FixedExtentScrollController controller,
    int targetIndex,
  ) {
    if (!controller.hasClients) return;
    if (controller.selectedItem == targetIndex) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !controller.hasClients) return;
      if (controller.selectedItem == targetIndex) return;

      controller.animateToItem(
        targetIndex,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
      );
    });
  }

  Widget _buildWheel({
    required List<int> options,
    required FixedExtentScrollController controller,
    required int selectedValue,
    required ValueChanged<int> onSelected,
  }) {
    final selectedIndex = options.indexOf(selectedValue);
    _syncControllerToValue(controller, selectedIndex == -1 ? 0 : selectedIndex);

    return SizedBox(
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: ListWheelScrollView.useDelegate(
              controller: controller,
              itemExtent: 48,
              diameterRatio: 1.5,
              perspective: 0.0025,
              squeeze: 1,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (index) => onSelected(options[index]),
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: options.length,
                builder: (context, index) {
                  final value = options[index];
                  final isSelected = value == selectedValue;

                  return Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeOut,
                      style: TextStyle(
                        fontSize: isSelected ? 30 : 22,
                        fontWeight: isSelected
                            ? FontWeight.w800
                            : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.42),
                        height: 1,
                      ),
                      child: Text('$value'),
                    ),
                  );
                },
              ),
            ),
          ),
          IgnorePointer(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.30),
                          Colors.black.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withValues(alpha: 0.28),
                      ),
                      bottom: BorderSide(
                        color: Colors.white.withValues(alpha: 0.28),
                      ),
                    ),
                    color: Colors.white.withValues(alpha: 0.04),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.30),
                          Colors.black.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _numeratorController.dispose();
    _denominatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MetronomeGlobalProvider>(
      builder: (context, metronomeProvider, child) {
        final numerator =
            _numeratorOptions.contains(metronomeProvider.compasNumerator)
            ? metronomeProvider.compasNumerator
            : _numeratorOptions[3];
        final denominator =
            _denominatorOptions.contains(metronomeProvider.compasDenominator)
            ? metronomeProvider.compasDenominator
            : _denominatorOptions[2];

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Compas').xSmall().medium(),
            const Gap(14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 92,
                  child: _buildWheel(
                    options: _numeratorOptions,
                    controller: _numeratorController,
                    selectedValue: numerator,
                    onSelected: (value) {
                      metronomeProvider.setCompasSignature(value, denominator);
                    },
                  ),
                ),
                const Gap(16),
                Text('/').xLarge().medium(),
                const Gap(16),
                SizedBox(
                  width: 92,
                  child: _buildWheel(
                    options: _denominatorOptions,
                    controller: _denominatorController,
                    selectedValue: denominator,
                    onSelected: (value) {
                      metronomeProvider.setCompasSignature(numerator, value);
                    },
                  ),
                ),
              ],
            ),
            const Gap(12),
            Text(metronomeProvider.compasLabel).small().medium(),
            const Gap(16),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: () => Navigator.pop(context),
                alignment: Alignment.center,
                child: Text('Listo').xSmall(),
              ),
            ),
          ],
        );
      },
    );
  }
}
