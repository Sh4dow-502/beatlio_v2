import 'package:beatlio_v2/models/serie.dart';
import 'package:beatlio_v2/provider/new_session_provider.dart';
import 'package:beatlio_v2/screens/new_sesion_screen/components/custom_alert_dialog.dart';
import 'package:beatlio_v2/screens/new_sesion_screen/components/form_new_exercise/form_new_excercise.dart';
import 'package:beatlio_v2/ui/components/container_exercise.dart';
import 'package:beatlio_v2/ui/components/icon_drag.dart';
import 'package:beatlio_v2/ui/components/material_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn hide Colors;

class ListExerciseInSerie extends StatelessWidget {
  final int index;
  final Serie serie;

  const ListExerciseInSerie({
    super.key,
    required this.serie,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    if (serie.exercises.isEmpty) {
      return const SizedBox.shrink();
    }

    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: false,
      itemBuilder: (context, index) {
        final exercise = serie.exercises[index];
        return Padding(
          key: ValueKey(exercise.uid),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: ContainerExercise(
            leadingIconDrag: ReorderableDragStartListener(
              index: index,
              child: IconDrag(iconColor: Colors.white.withValues(alpha: 0.2)),
            ),
            exercise: exercise,
            index: index,
            bgColor: Color(0xff151515),
            isSerie: false,
            globalBpm: exercise.bpm != serie.bpmValueGlobal ? true : false,
            onDelete: () {
              final result = shadcn.showDialog<bool>(
                context: context,
                builder: (context) => const CustomAlertDialog(),
              );

              result.then((value) {
                if (value ?? false) {
                  if (!context.mounted) return;
                  context.read<NewSessionProvider>().deleteExerciseInSerieByUid(
                    serie.uid,
                    exercise.uid,
                  );
                }
              });
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
                      // serieUid: serie.uid,
                      isEdit: true,
                      exercise: exercise,
                      isSerie: true,
                      serie: serie,
                    ),
                  );
                },
              );
            },
          ),
        );
      },
      itemCount: serie.exercises.length,
      onReorderStart: (_) {
        HapticFeedback.heavyImpact();
      },
      onReorder: (oldIndex, newIndex) {
        context.read<NewSessionProvider>().reorderExerciseInSerieByUid(
          serie.uid,
          oldIndex,
          newIndex,
        );
      },
    );
  }
}
