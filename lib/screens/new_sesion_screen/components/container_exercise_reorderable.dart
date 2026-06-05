import 'package:beatlio_v2/models/exercise.dart';
import 'package:beatlio_v2/provider/new_session_provider.dart';
import 'package:beatlio_v2/screens/new_sesion_screen/components/custom_alert_dialog.dart';
import 'package:beatlio_v2/screens/new_sesion_screen/components/form_new_exercise/form_new_excercise.dart';
import 'package:beatlio_v2/ui/components/container_exercise.dart';
import 'package:beatlio_v2/ui/components/icon_drag.dart';
import 'package:beatlio_v2/ui/components/material_bottom_sheet.dart';
import 'package:flutter/material.dart' hide showDialog;
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

class ContainerExerciseReorderable extends StatelessWidget {
  final Exercise exercise;
  final int index;
  final bool reorderMode;

  const ContainerExerciseReorderable({
    super.key,
    required this.exercise,
    required this.index,
    this.reorderMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: reorderMode
          ? ContainerExercise(
              exercise: exercise,
              index: index,
              leadingIconDrag: ReorderableDelayedDragStartListener(
                index: index,
                child: IconDrag(),
              ),
              onDelete: () async {
                final result = await shadcn.showDialog<bool>(
                  context: context,
                  builder: (context) => const CustomAlertDialog(),
                );
                if (result != true) return;
                if (!context.mounted) return;

                context.read<NewSessionProvider>().deleteExercise(exercise.uid);
              },
              onEdit: () {
                openMaterialSheet(
                  context: context,
                  builder: (context) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 5,
                      ),
                      child: FormNewExcercise(
                        exercise: exercise,
                        // index: index,
                        isEdit: true,
                      ),
                    );
                  },
                );
              },
            )
          : ReorderableDelayedDragStartListener(
              index: index,
              child: ContainerExercise(
                exercise: exercise,
                index: index,
                onDelete: () async {
                  final result = await shadcn.showDialog<bool>(
                    context: context,
                    builder: (context) => const CustomAlertDialog(),
                  );
                  if (result != true) return;
                  if (!context.mounted) return;

                  context.read<NewSessionProvider>().deleteExercise(
                    exercise.uid,
                  );
                },
                onEdit: () {
                  openMaterialSheet(
                    context: context,
                    builder: (context) {
                      return SingleChildScrollView(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom + 5,
                        ),
                        child: FormNewExcercise(
                          exercise: exercise,
                          // index: index,
                          isEdit: true,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
