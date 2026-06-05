import 'package:shadcn_flutter/shadcn_flutter.dart';

class IconDrag extends StatelessWidget {
  final Color? iconColor;

  const IconDrag({super.key, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        Icons.drag_indicator_rounded,
        color: iconColor ?? Colors.white.withValues(alpha: 0.3),
      ),
      variance: ButtonStyle.textIcon(),
      density: ButtonDensity.dense,
    );
  }
}
