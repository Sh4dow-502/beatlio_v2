import 'package:beatlio_v2/models/serie.dart';
import 'package:beatlio_v2/screens/new_sesion_screen/components/list_series/add_exercise_button.dart';
import 'package:beatlio_v2/screens/new_sesion_screen/components/list_series/list_exercise_in_serie.dart';
import 'package:flutter/material.dart' hide Card, Column, Expanded, Row, Text;
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ContainerSerie extends StatelessWidget {
  const ContainerSerie({super.key, required this.serie, required this.index});

  final Serie serie;
  final int index;

  @override
  Widget build(BuildContext context) {
    final hasExercises = serie.exercises.isNotEmpty;

    return Card(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      borderRadius: BorderRadius.circular(18),
      child: Accordion(
        items: [
          AccordionItem(
            trigger: AccordionTrigger(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [Text(serie.name).small()]),
                  Row(
                    spacing: 6,
                    children: [
                      Text(
                        "${serie.exercises.length} ${serie.exercises.length == 1 ? "ejercicio" : "ejercicios"}",
                      ).xSmall().muted(),
                      Text("•"),
                      Text(serie.totalTime()).xSmall().muted(),

                      if (serie.bpmGlobal) ...[
                        Text("•"),
                        Text(
                          "${serie.bpmValueGlobal ?? 0} bpm",
                        ).xSmall().muted(),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            content: hasExercises
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListExerciseInSerie(serie: serie, index: index),
                      const Gap(7),
                      AddExerciseButton(serie: serie, index: index),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(10),
                      Text("No tiene ningún ejercicio").xSmall().muted(),
                      const Gap(10),
                      AddExerciseButton(serie: serie, index: index),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
