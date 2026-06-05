import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:beatlio/utils/app_constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? maxLines;
  final InputBorder? border;
  final Function(String)? onSubmitted;
  final Function(PointerDownEvent)? onTapOutside;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? style;
  final TextAlign? textAlign;

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.contentPadding,
    this.fillColor,
    this.onChanged,
    this.focusNode,
    this.autofocus = false,
    this.textInputAction,
    this.keyboardType,
    this.maxLength,
    this.maxLines = 1,
    this.border,
    this.onSubmitted,
    this.onTapOutside,
    this.inputFormatters,
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final hintStyle = TextStyle(color: colors.outline);
    final borderTextField = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: colors.secondary.withValues(alpha: 0.9)),
    );
    final focusedBorderTextField = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: colors.primary),
    );

    return TextField(
      onSubmitted: (value) {
        if (onSubmitted != null) {
          onSubmitted!(controller?.text ?? "");
        }
        FocusScope.of(context).unfocus();
      },
      onTapOutside: (event) {
        if (onTapOutside != null) {
          onTapOutside!(PointerDownEvent());
        }

        FocusScope.of(context).unfocus();
      },
      maxLines: maxLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      focusNode: focusNode,
      autofocus: autofocus,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      style: style,
      textAlign: textAlign ?? TextAlign.start,
      textCapitalization: TextCapitalization.sentences,
      controller: controller,
      decoration: InputDecoration(
        hintMaxLines: 1,
        contentPadding: contentPadding,
        fillColor: fillColor ?? colors.surface,
        filled: true,
        labelText: labelText,
        hintText: hintText,
        hintStyle: style ?? hintStyle,
        labelStyle: hintStyle,
        border: border ?? borderTextField,
        enabledBorder: border ?? borderTextField,
        focusedBorder: border ?? focusedBorderTextField,
        counter: const SizedBox.shrink(),
      ),
    );
  }
}
