import 'package:shadcn_flutter/shadcn_flutter.dart';

class CustomButton extends StatelessWidget {
  final Function()? onPressed;
  final String text;

  const CustomButton({super.key, this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(text).xSmall(),
      ),
    );
  }
}
