import 'package:beatlio_v2/ui/components/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BpmWheelCenter extends StatelessWidget {
  const BpmWheelCenter({
    super.key,
    required this.bpm,
    required this.isEditing,
    required this.controller,
    required this.focusNode,
    required this.onTap,
    required this.onChanged,
    required this.onSubmitted,
    required this.onTapOutside,
  });

  final int bpm;
  final bool isEditing;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onTap;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final Function(PointerDownEvent) onTapOutside;

  @override
  Widget build(BuildContext context) {
    final centerText = Text(
      '$bpm',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        height: 1,
      ),
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: isEditing
          ? SizedBox(
              width: 115,
              child: CustomTextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: true,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                maxLength: 3,
                maxLines: 1,
                fillColor: Colors.black.withValues(alpha: 0.28),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 3,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.14),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
                textAlign: TextAlign.center,
                onChanged: onChanged,
                onSubmitted: onSubmitted,
                onTapOutside: onTapOutside,
              ),
            )
          : GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: SizedBox(
                width: 115,
                // height: 56,
                child: Center(child: centerText),
              ),
            ),
    );
  }
}
