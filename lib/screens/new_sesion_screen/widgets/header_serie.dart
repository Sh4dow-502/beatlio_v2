// import 'package:beatlio_v2/screens/new_sesion_screen/components/form_new_serie.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
// import 'package:flutter/material.dart';

class HeaderSerie extends StatelessWidget {
  const HeaderSerie({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Series").small(fontWeight: FontWeight.w500),
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
        //           child: FormNewSerie(),
        //           // child: FormNewExcercise(),
        //         );
        //       },
        //       position: OverlayPosition.bottom,
        //     );
        //   },
        //   size: ButtonSize.normal,
        //   alignment: Alignment.center,
        //   child: Text("Serie").xSmall(),
        // ),
      ],
      // children: [
      //   Text("Series"),
      //   GestureDetector(
      //     onTap: () {
      //       showModalBottomSheet(
      //         context: context,
      //         builder: (BuildContext context) {
      //           return SingleChildScrollView(
      //             padding: EdgeInsets.only(
      //               bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      //             ),
      //             child: FormNewSerie(),
      //           );
      //         },
      //       );
      //     },
      //     child: Container(
      //       decoration: BoxDecoration(
      //         color: Colors.blueAccent,
      //         borderRadius: BorderRadius.circular(12),
      //       ),
      //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      //       child: Row(
      //         spacing: 5,
      //         children: [
      //           Text("Agregar Serie", style: TextStyle(color: Colors.white)),
      //           Icon(Icons.add, color: Colors.white),
      //         ],
      //       ),
      //     ),
      //   ),
      // ],
    );
  }
}
