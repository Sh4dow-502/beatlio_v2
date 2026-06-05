import 'package:beatlio_v2/models/serie.dart';
import 'package:beatlio_v2/screens/new_sesion_screen/components/form_new_exercise/form_new_excercise.dart';
import 'package:beatlio_v2/ui/components/material_bottom_sheet.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class AddExerciseButton extends StatefulWidget {
  const AddExerciseButton({
    super.key,
    required this.serie,
    required this.index,
  });

  final Serie serie;
  final int index;

  @override
  State<AddExerciseButton> createState() => _AddExerciseButtonState();
}

class _AddExerciseButtonState extends State<AddExerciseButton> {
  final GlobalKey _buttonKey = GlobalKey();
  late int _lastExerciseCount;

  @override
  void initState() {
    super.initState();
    _lastExerciseCount = widget.serie.exercises.length;
  }

  @override
  void didUpdateWidget(covariant AddExerciseButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newCount = widget.serie.exercises.length;
    if (newCount > _lastExerciseCount) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final currentContext = _buttonKey.currentContext;
        if (!mounted || currentContext == null) return;

        Scrollable.ensureVisible(
          currentContext,
          duration: const Duration(milliseconds: 260),
          alignment: 1,
          alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
        );
      });
    }
    _lastExerciseCount = newCount;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlineButton(
          key: _buttonKey,
          alignment: Alignment.center,
          enableFeedback: true,
          onPressed: () {
            openMaterialSheet(
              context: context,
              builder: (context) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 5,
                  ),
                  child: FormNewExcercise(
                    isSerie: true,
                    serie: widget.serie,
                    // serieUid: serie.uid,
                  ),
                );
              },
            );
          },
          // child: Text("Ejercicio").xSmall(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                BootstrapIcons.plus,
                // size: 14,
              ),
              const Gap(5),
              Text("Agregar ejercicio").xSmall(),
            ],
          ),
          // density: ButtonDensity.,
        ),
      ],
    );
  }
}
