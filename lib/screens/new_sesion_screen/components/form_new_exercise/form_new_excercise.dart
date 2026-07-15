import 'package:beatlio_v2/models/exercise.dart';
import 'package:beatlio_v2/models/serie.dart';
import 'package:beatlio_v2/provider/new_session_provider.dart';
import 'package:beatlio_v2/screens/new_sesion_screen/components/form_new_exercise/bpm_controller.dart';
import 'package:beatlio_v2/screens/new_sesion_screen/components/form_new_exercise/duration_controller.dart';
import 'package:beatlio_v2/ui/components/custom_text_field.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:uuid/uuid.dart';

class FormNewExcercise extends StatefulWidget {
  final bool? isSerie;
  final Serie? serie;
  // final String? serieUid;
  final bool isEdit;
  final Exercise? exercise;

  const FormNewExcercise({
    super.key,
    this.isSerie = false,
    this.serie,
    // this.serieUid,
    this.isEdit = false,
    this.exercise,
  });

  @override
  State<FormNewExcercise> createState() => _FormNewExcerciseState();
}

class _FormNewExcerciseState extends State<FormNewExcercise> {
  final TextEditingController nameController = TextEditingController();

  int duration = 300;
  int bpm = 120;

  bool errorName = false;

  /// La serie permite usar configuración global
  bool switchBpmEnabled = false;
  bool switchDurationEnabled = false;

  /// El ejercicio usa configuración global
  bool useGlobalBpm = false;
  bool useGlobalDuration = false;

  String uid = const Uuid().v4();

  bool get hasSerieGlobalConfig {
    return widget.isSerie == true &&
        (switchBpmEnabled || switchDurationEnabled);
  }

  @override
  void initState() {
    super.initState();

    /// Configuración de serie
    if (widget.isSerie == true && widget.serie != null) {
      switchBpmEnabled = widget.serie!.bpmGlobal;
      switchDurationEnabled = widget.serie!.durationGlobal;
    }

    /// Editando ejercicio
    if (widget.isEdit && widget.exercise != null) {
      final exercise = widget.exercise!;

      nameController.text = exercise.name;

      duration = exercise.duration;
      bpm = exercise.bpm;

      uid = exercise.uid;

      useGlobalBpm = exercise.useGlobalBpm;
      useGlobalDuration = exercise.useGlobalDuration;
    } else {
      /// Valores por defecto
      if (widget.serie != null) {
        duration = widget.serie!.durationValueGlobal ?? 300;
        bpm = widget.serie!.bpmValueGlobal ?? 120;

        useGlobalBpm = widget.serie!.bpmGlobal;
        useGlobalDuration = widget.serie!.durationGlobal;
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void setBpm(int value) {
    bpm = value;
    setState(() {});
  }

  void setDuration(int value) {
    duration = value;
    setState(() {});
  }

  bool validateName(String name) {
    if (name.trim().isEmpty) {
      errorName = true;
      setState(() {});
      return false;
    }

    errorName = false;
    setState(() {});
    return true;
  }

  void saveExercise() {
    if (!validateName(nameController.text)) {
      return;
    }

    final exercise = Exercise(
      name: nameController.text.trim(),
      duration: duration,
      bpm: bpm,
      uid: uid,
      useGlobalBpm: useGlobalBpm,
      useGlobalDuration: useGlobalDuration,
    );

    /// Dentro de serie
    if (widget.isSerie == true && widget.serie != null) {
      if (widget.isEdit) {
        context.read<NewSessionProvider>().editExerciseInSerieByUid(
          widget.serie!.uid,
          exercise.uid,
          exercise,
        );
      } else {
        context.read<NewSessionProvider>().addExerciseInSerieByUid(
          exercise,
          widget.serie!.uid,
        );
      }

      return;
    }

    /// Ejercicio normal
    if (widget.isEdit) {
      context.read<NewSessionProvider>().editExerciseByUid(
        widget.exercise!.uid,
        exercise,
      );
    } else {
      context.read<NewSessionProvider>().addExercise(exercise);
    }
  }

  Widget buildMiniBadge(String text, {Key? key}) {
    final colors = Theme.of(context).colorScheme;

    return Align(
      key: key,
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: colors.primary.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: colors.primary.withValues(alpha: 0.26)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: colors.primary.withValues(alpha: 0.9),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 1.1,
          ),
        ),
      ),
    );
  }

  Widget buildAnimatedSwap({
    required bool showController,
    required Widget controller,
    required String badgeText,
    required String animationKey,
  }) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 240),
      reverseDuration: const Duration(milliseconds: 180),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return ClipRect(
          child: FadeTransition(
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              axisAlignment: -1,
              child: child,
            ),
          ),
        );
      },
      child: showController
          ? Padding(
              key: ValueKey('$animationKey-controller'),
              padding: const EdgeInsets.only(top: 8),
              child: controller,
            )
          : buildMiniBadge(badgeText, key: ValueKey('$animationKey-badge')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(15),

          /// NAME
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                autofocus: widget.isEdit ? false : true,
                maxLength: 25,
                labelText: 'Nombre del ejercicio',
                controller: nameController,
                onChanged: validateName,
              ),

              const Gap(2),

              if (errorName)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 5),
                  child: Text(
                    'El nombre no puede estar vacío',
                    style: const TextStyle(fontSize: 12, color: Colors.red),
                  ),
                ),
            ],
          ),

          /// SERIE INFO
          if (widget.isSerie == true && widget.serie != null) ...[
            const Gap(20),
            Row(
              children: [
                Text('Serie:').xSmall().muted(),
                const Gap(5),
                Text(widget.serie!.name).xSmall().bold(),
              ],
            ),

            const Gap(6),
          ],

          /// EJERCICIO DENTRO DE SERIE
          if (widget.isSerie == true) ...[
            /// BPM
            if (switchBpmEnabled) ...[
              const Gap(6),

              GestureDetector(
                onTap: () {
                  HapticFeedback.heavyImpact();

                  setState(() {
                    useGlobalBpm = !useGlobalBpm;

                    if (useGlobalBpm && widget.serie != null) {
                      bpm = widget.serie!.bpmValueGlobal ?? bpm;
                    }
                  });
                },

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('BPM propio').xSmall(),

                        Text(
                          !useGlobalBpm
                              ? 'Este ejercicio usa su propio BPM'
                              : 'Usa el BPM global de la serie',
                          textScaler: const TextScaler.linear(0.9),
                        ).xSmall().muted(),
                      ],
                    ),

                    Switch(
                      value: !useGlobalBpm,
                      onChanged: (value) {
                        setState(() {
                          useGlobalBpm = !value;

                          if (useGlobalBpm && widget.serie != null) {
                            bpm = widget.serie!.bpmValueGlobal ?? bpm;
                          }
                        });
                      },
                    ).small(),
                  ],
                ),
              ),

              const Gap(5),

              buildAnimatedSwap(
                showController: !useGlobalBpm,

                controller: BPMController(
                  initialBPM: bpm,
                  onBPMChanged: setBpm,
                ),

                badgeText:
                    'Usando configuración global: ${widget.serie?.bpmValueGlobal ?? bpm} BPM',

                animationKey: 'bpm',
              ),
            ] else ...[
              const Gap(18),

              BPMController(initialBPM: bpm, onBPMChanged: setBpm),
            ],

            /// DURATION
            if (switchDurationEnabled) ...[
              const Gap(25),

              GestureDetector(
                onTap: () {
                  HapticFeedback.heavyImpact();

                  setState(() {
                    useGlobalDuration = !useGlobalDuration;

                    if (useGlobalDuration && widget.serie != null) {
                      duration = widget.serie!.durationValueGlobal ?? duration;
                    }
                  });
                },

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Duración propia').xSmall(),

                        Text(
                          !useGlobalDuration
                              ? 'Este ejercicio usa su propia duración'
                              : 'Usa la duración global de la serie',
                          textScaler: const TextScaler.linear(0.9),
                        ).xSmall().muted(),
                      ],
                    ),

                    Switch(
                      value: !useGlobalDuration,
                      onChanged: (value) {
                        setState(() {
                          useGlobalDuration = !value;

                          if (useGlobalDuration && widget.serie != null) {
                            duration =
                                widget.serie!.durationValueGlobal ?? duration;
                          }
                        });
                      },
                    ).small(),
                  ],
                ),
              ),

              const Gap(5),

              buildAnimatedSwap(
                showController: !useGlobalDuration,

                controller: DurationController(
                  initialDuration: duration,
                  onDurationChanged: setDuration,
                ),

                badgeText:
                    'Usando configuración global: ${(widget.serie?.durationValueGlobal ?? duration) ~/ 60} min',

                animationKey: 'duration',
              ),
            ] else ...[
              const Gap(18),

              DurationController(
                initialDuration: duration,
                onDurationChanged: setDuration,
              ),
            ],
          ] else ...[
            /// EJERCICIO NORMAL
            const Gap(18),

            BPMController(initialBPM: bpm, onBPMChanged: setBpm),

            const Gap(18),

            DurationController(
              initialDuration: duration,
              onDurationChanged: setDuration,
            ),
          ],

          const Gap(40),

          /// BUTTON
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  alignment: Alignment.center,
                  density: ButtonDensity.normal,
                  onPressed: () {
                    HapticFeedback.lightImpact();

                    if (validateName(nameController.text)) {
                      saveExercise();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ),
            ],
          ),

          const Gap(20),
        ],
      ),
    );
  }
}
