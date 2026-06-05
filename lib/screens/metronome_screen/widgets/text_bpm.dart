import 'package:beatlio_v2/provider/metronome_global_provider.dart';
import 'package:beatlio_v2/screens/metronome_screen/widgets/bpm_wheel_center.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class TextBPM extends StatefulWidget {
  const TextBPM({super.key});

  @override
  State<TextBPM> createState() => _TextBPMState();
}

class _TextBPMState extends State<TextBPM> {
  final int _minBpm = MetronomeGlobalProvider.minBpm;
  final int _maxBpm = MetronomeGlobalProvider.maxBpm;

  late final FixedExtentScrollController _scrollController;
  late final TextEditingController _bpmController;
  late final FocusNode _bpmFocusNode;
  late int _lastSyncedBpm;
  bool _didInitialize = false;
  bool _isEditingBpm = false;

  @override
  void initState() {
    super.initState();
    _bpmController = TextEditingController();
    _bpmFocusNode = FocusNode();
    _bpmFocusNode.addListener(_handleBpmFocusChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInitialize) return;

    final initialBpm = context.read<MetronomeGlobalProvider>().bpm.clamp(
      _minBpm,
      _maxBpm,
    );
    _lastSyncedBpm = initialBpm;
    _bpmController.text = initialBpm.toString();
    _scrollController = FixedExtentScrollController(
      initialItem: initialBpm - _minBpm,
    );
    _didInitialize = true;
  }

  void _handleBpmFocusChange() {
    if (_bpmFocusNode.hasFocus) return;
    if (!_isEditingBpm) return;

    final provider = context.read<MetronomeGlobalProvider>();
    _commitBpmInput(provider, _bpmController.text);
  }

  void _syncWheelToProvider(int providerBpm) {
    if (_lastSyncedBpm == providerBpm) return;

    _lastSyncedBpm = providerBpm;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!_scrollController.hasClients) return;

      final targetIndex = providerBpm - _minBpm;

      if (_scrollController.selectedItem == targetIndex) {
        return;
      }

      _scrollController.animateToItem(
        targetIndex,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _enterBpmEditMode(int bpm) {
    final bpmText = bpm.toString();
    _bpmController.value = TextEditingValue(
      text: bpmText,
      selection: TextSelection.collapsed(offset: bpmText.length),
      composing: TextRange.empty,
    );

    setState(() {
      _isEditingBpm = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _bpmFocusNode.requestFocus();
    });
  }

  void _exitBpmEditMode() {
    if (!_isEditingBpm) return;
    setState(() {
      _isEditingBpm = false;
    });
  }

  String _digitsOnly(String value) {
    return value.replaceAll(RegExp(r'[^0-9]'), '');
  }

  int _clampBpm(int value) {
    if (value < _minBpm) return _minBpm;
    if (value > _maxBpm) return _maxBpm;
    return value;
  }

  void _syncInputText(String value) {
    if (_bpmController.text == value) return;
    _bpmController.value = _bpmController.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
      composing: TextRange.empty,
    );
  }

  void _commitBpmInput(MetronomeGlobalProvider provider, String rawValue) {
    final digits = _digitsOnly(rawValue);
    if (digits.isEmpty) {
      _syncInputText(provider.bpm.toString());
      _exitBpmEditMode();
      return;
    }

    final parsedValue = int.tryParse(digits) ?? provider.bpm;
    final clampedValue = _clampBpm(parsedValue);
    provider.setBpm(clampedValue);
    _syncInputText(clampedValue.toString());
    _exitBpmEditMode();
  }

  @override
  void dispose() {
    _bpmFocusNode
      ..removeListener(_handleBpmFocusChange)
      ..dispose();
    _bpmController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<MetronomeGlobalProvider, int>(
      selector: (_, provider) => provider.bpm,
      builder: (context, providerBpm, child) {
        final clampedBpm = providerBpm.clamp(_minBpm, _maxBpm);

        _syncWheelToProvider(clampedBpm);

        if (!_isEditingBpm) {
          _syncInputText(clampedBpm.toString());
        }

        return SizedBox(
          height: 75,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: RotatedBox(
                  quarterTurns: -1,
                  child: ListWheelScrollView.useDelegate(
                    controller: _scrollController,
                    itemExtent: 88,
                    diameterRatio: 2.2,
                    perspective: 0.003,
                    squeeze: 1,
                    physics: _isEditingBpm
                        ? const NeverScrollableScrollPhysics()
                        : const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      final provider = context.read<MetronomeGlobalProvider>();

                      final selectedBpm = _minBpm + index;

                      _lastSyncedBpm = selectedBpm;

                      if (selectedBpm != provider.bpm) {
                        provider.setBpm(selectedBpm);
                      }
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: (_maxBpm - _minBpm) + 1,
                      builder: (context, index) {
                        final bpm = _minBpm + index;
                        final isSelected = bpm == clampedBpm;

                        return RotatedBox(
                          quarterTurns: 1,
                          child: Center(
                            child: isSelected
                                ? BpmWheelCenter(
                                    bpm: bpm,
                                    isEditing: _isEditingBpm,
                                    controller: _bpmController,
                                    focusNode: _bpmFocusNode,
                                    onTap: () => _enterBpmEditMode(bpm),
                                    onChanged: (value) {
                                      final digits = _digitsOnly(value);

                                      if (digits != value) {
                                        _syncInputText(digits);
                                      }
                                    },
                                    onSubmitted: (value) {
                                      _commitBpmInput(
                                        context.read<MetronomeGlobalProvider>(),
                                        value,
                                      );
                                    },
                                    onTapOutside: (event) {
                                      _commitBpmInput(
                                        context.read<MetronomeGlobalProvider>(),
                                        _bpmController.text,
                                      );
                                    },
                                  )
                                : AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 120),
                                    curve: Curves.easeOut,
                                    style: TextStyle(
                                      fontSize: 37,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withValues(
                                        alpha: 0.42,
                                      ),
                                      height: 1,
                                    ),
                                    child: Text('$bpm'),
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              IgnorePointer(
                child: Row(
                  children: [
                    Container(
                      width: 96,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.black.withValues(alpha: 0.78),
                            Colors.black.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 96,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                            Colors.black.withValues(alpha: 0.78),
                            Colors.black.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
