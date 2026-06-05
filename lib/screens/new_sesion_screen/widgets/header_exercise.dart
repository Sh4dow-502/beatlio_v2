// import 'package:beatlio_v2/screens/new_sesion_screen/components/form_new_excercise.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class HeaderExercise extends StatelessWidget {
  const HeaderExercise({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Ejercicios").small(fontWeight: FontWeight.w500),
        // PrimaryButton(
        //   leading: Icon(BootstrapIcons.plus),
        //   onPressed: () {
        //     openSheet(
        //       draggable: true,
        //       transformBackdrop: true,
        //       context: context,
        //       builder: (context) {
        //         return SingleChildScrollView(
        //           padding: EdgeInsets.only(
        //             bottom: MediaQuery.of(context).viewInsets.bottom + 5,
        //           ),
        //           child: FormNewExcercise(),
        //         );
        //       },
        //       position: OverlayPosition.bottom,
        //     );
        //   },
        //   size: ButtonSize.normal,
        //   alignment: Alignment.center,
        //   child: Text("Ejercicio").xSmall(),
        // ),
      ],
    );
  }
}
