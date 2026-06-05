import 'package:beatlio_v2/provider/metronome_provider.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ControllerCompas extends StatelessWidget {
  const ControllerCompas({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MetronomeProvider>(
      builder: (context, metronomeProvider, child) {
        final options = <_CompasOption>[
          _CompasOption(label: '2/4', value: 2),
          _CompasOption(label: '3/4', value: 3),
          _CompasOption(label: '4/4', value: 4),
          _CompasOption(label: '6/8', value: 6),
        ];

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < options.length; i++) ...[
              Button.secondary(
                onPressed: () {
                  switch (options[i].label) {
                    case '6/8':
                      metronomeProvider.setCompasSignature(6, 8);
                      break;
                    default:
                      metronomeProvider.setCompasSignature(options[i].value, 4);
                  }
                },
                style: ButtonStyle(
                  variance: metronomeProvider.compasLabel == options[i].label
                      ? ButtonStyle.secondary()
                      : ButtonStyle.outline(),
                ),
                child: Text(options[i].label).xSmall().semiBold(),
              ),
              if (i != options.length - 1) const Gap(10),
            ],
          ],
        );
      },
    );
  }
}

class _CompasOption {
  final String label;
  final int value;

  const _CompasOption({required this.label, required this.value});
}
