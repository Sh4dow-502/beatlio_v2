import 'package:shadcn_flutter/shadcn_flutter.dart';

class ButtonGeneral extends StatelessWidget {
  final Widget child;
  final Function() onPressed;
  const ButtonGeneral({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        padding: const EdgeInsets.all(2),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(13),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
