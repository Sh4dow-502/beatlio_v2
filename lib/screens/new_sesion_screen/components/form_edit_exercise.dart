import 'package:beatlio_v2/models/exercise.dart';
import 'package:beatlio_v2/provider/new_session_provider.dart';
import 'package:beatlio_v2/ui/components/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class FormEditExercise extends StatefulWidget {
  final bool? isSerie;
  final int? serieId;
  final Exercise exercise;
  final int exerciseId;

  const FormEditExercise({
    super.key,
    required this.exercise,
    required this.exerciseId,
    this.isSerie = false,
    this.serieId,
  });

  @override
  State<FormEditExercise> createState() => _FormEditExerciseState();
}

class _FormEditExerciseState extends State<FormEditExercise> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController bpmController = TextEditingController();

  int duration = 60;
  int bpm = 120;

  @override
  void initState() {
    nameController.text = widget.exercise.name;
    durationController.text = widget.exercise.duration.toString();
    bpmController.text = widget.exercise.bpm.toString();

    duration = widget.exercise.duration;
    bpm = widget.exercise.bpm;

    super.initState();
  }

  void saveExercise() {
    final Exercise exercise = Exercise(
      name: nameController.text,
      uid: Uuid().v4(),
      duration: int.tryParse(durationController.text) ?? 60,
      bpm: int.tryParse(bpmController.text) ?? 120,
    );

    widget.isSerie! == true
        ? context.read<NewSessionProvider>().editExerciseInSerie(
            widget.exerciseId,
            widget.serieId!,
            exercise,
          )
        : context.read<NewSessionProvider>().editExercise(
            widget.exerciseId,
            exercise,
          );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Text("${widget.exercise.name} (Editar)"),
            const SizedBox(height: 15),
            CustomTextField(
              labelText: "Nombre del ejercicio",
              controller: nameController,
            ),

            // TextField(
            //   decoration: InputDecoration(labelText: 'Nombre del ejercicio'),
            //   controller: nameController,
            // ),
            CustomTextField(
              labelText: "Duración (60s)",
              controller: durationController,
            ),
            CustomTextField(labelText: "BPM (120)", controller: bpmController),
          ],
        ),
      ),
    );
  }
}

//                       decoration: InputDecoration(labelText: 'Duración (60s)'),
//                       controller: durationController,
//                     ),
//                   ),
//                   Expanded(
//                     child: TextField(
//                       decoration: InputDecoration(labelText: 'BPM (120)'),
//                       controller: bpmController,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Spacer(),
//             ElevatedButton(
//               onPressed: () {
//                 saveExercise();
//               },
//               child: Text("Guardar"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
