import 'package:shadcn_flutter/shadcn_flutter.dart';

class CustomBadge extends StatelessWidget {
  final String text;
  final Function()? onTap;
  final bool selected;
  final Color? color;
  const CustomBadge({
    super.key,
    required this.text,
    this.onTap,
    this.selected = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? (color ?? colors.secondary) : colors.background,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: colors.secondary),
        ),
        child: Text(text, textScaler: TextScaler.linear(0.8)).xSmall(),
      ),
    );
  }
}
