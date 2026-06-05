import 'package:beatlio_v2/screens/session_screen/widgets/button_back.dart';
import 'package:beatlio_v2/screens/session_screen/widgets/button_next.dart';
import 'package:beatlio_v2/screens/session_screen/widgets/button_play.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ControlsMedia extends StatelessWidget {
  const ControlsMedia({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonPrevious(),
        const Gap(20),
        ButtonPlay(),
        const Gap(20),
        ButtonNext(),
      ],
    );
  }
}
