import 'package:flutter/material.dart';
import 'package:gradient_slider/gradient_slider.dart';

class CustomGradientSlider extends StatelessWidget {
  const CustomGradientSlider({
    super.key,
    required this.gradientColors,
    required this.value,
    // required this.varCond,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.label,
    this.onChanged,
    this.dotColor,
    this.primaryColor,
    this.borderColor,
    this.trackHeight = 3,
    this.inactiveColor,
    this.onChangeEnd,
  });

  final List<Color> gradientColors;
  final Color? primaryColor;
  final double value;
  final double min;
  final double max;
  // final double varCond;
  final int? divisions;
  final String? label;
  final Function(double)? onChanged;
  final Color? dotColor;
  final Color? borderColor;
  final double? trackHeight;
  final Color? inactiveColor;
  final Function(double)? onChangeEnd;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 20,
      child: SliderTheme(
        data: SliderThemeData(
          padding: EdgeInsets.zero,
          tickMarkShape: SliderTickMarkShape.noTickMark,
          activeTickMarkColor: Colors.transparent,
          inactiveTickMarkColor: Colors.transparent,
          // disabledInactiveTrackColor: colors.tertiaryContainer,
          thumbColor: primaryColor ?? colors.primary,
          thumbShape: _CustomThumbShape(
            radius: 10,
            fillColor: colors.surface,
            borderColor: borderColor ?? colors.secondary,
            borderWidth: 1,
            innerDotColor: dotColor ?? colors.primary,
            innerDotRadius: 2,
          ),
          trackShape: GradientSliderTrackShape(
            activeTrackGradient: LinearGradient(colors: gradientColors),
          ),
          trackHeight: trackHeight,
          inactiveTrackColor:
              inactiveColor ?? colors.secondary.withValues(alpha: 0.24),
          activeTrackColor: primaryColor ?? colors.primary,
          rangeThumbShape: RoundRangeSliderThumbShape(enabledThumbRadius: 12),
          valueIndicatorColor: colors.surfaceContainer,
          valueIndicatorTextStyle: TextStyle(color: colors.secondary),
        ),
        child: Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          label: label,
          onChanged: onChanged,
          onChangeEnd: onChangeEnd,
        ),
      ),
    );
  }
}

class _CustomThumbShape extends SliderComponentShape {
  final double radius; // radio total de la bolita
  final Color borderColor;
  final double borderWidth;
  final Color? fillColor;
  final Color? innerDotColor;
  final double innerDotRadius;

  const _CustomThumbShape({
    this.radius = 12,
    this.borderColor = Colors.grey,
    this.borderWidth = 2,
    this.fillColor,
    this.innerDotColor,
    this.innerDotRadius = 4,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(radius + borderWidth);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    final fillPaintColor =
        fillColor ??
        sliderTheme.thumbColor ??
        sliderTheme.activeTrackColor ??
        Colors.transparent;
    final dotPaintColor =
        innerDotColor ??
        sliderTheme.thumbColor ??
        sliderTheme.activeTrackColor ??
        Colors.transparent;

    // 1️⃣ Círculo de relleno (alrededor del puntito)
    final fillPaint = Paint()
      ..color = fillPaintColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, fillPaint);

    // 2️⃣ Borde exterior
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawCircle(center, radius, borderPaint);

    if (innerDotRadius > 0) {
      // 3️⃣ Puntito en el centro
      final dotPaint = Paint()
        ..color = dotPaintColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, innerDotRadius, dotPaint);
    }
  }
}
