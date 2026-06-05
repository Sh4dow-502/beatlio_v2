import 'package:beatlio_v2/provider/new_session_provider.dart';
import 'package:beatlio_v2/screens/new_sesion_screen/components/container_exercise_reorderable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ListExercises extends StatefulWidget {
  const ListExercises({super.key});

  @override
  State<ListExercises> createState() => _ListExercisesState();
}

class _ListExercisesState extends State<ListExercises> {
  bool reorderMode = false;

  @override
  Widget build(BuildContext context) {
    final exercises = context.watch<NewSessionProvider>().exercises;

    return SlidableAutoCloseBehavior(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ejercicios",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reorderMode
                          ? "Modo reorder activo"
                          : "Mantén presionado el ejercicio para reordenar",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  setState(() {
                    reorderMode = !reorderMode;
                  });
                },
                tooltip: "Activar reorder",
                icon: Icon(
                  reorderMode ? Icons.swap_vert : Icons.swap_vert_outlined,
                ),
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(6),
                  side: BorderSide(
                    color: reorderMode
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white.withValues(alpha: 0.18),
                  ),
                  foregroundColor: reorderMode
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: exercises.isEmpty
                ? Center(
                    child: Text(
                      "No hay ejercicios agregados",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 17,
                      ),
                    ),
                  )
                : ReorderableListView.builder(
                    buildDefaultDragHandles: false,
                    itemBuilder: (context, index) {
                      final exercise = exercises[index];
                      return ContainerExerciseReorderable(
                        key: ValueKey(exercise.uid),
                        exercise: exercise,
                        index: index,
                        reorderMode: reorderMode,
                      );
                    },
                    itemCount: exercises.length,
                    proxyDecorator: (child, index, animation) {
                      return AnimatedBuilder(
                        animation: animation,
                        child: child,
                        builder: (context, child) {
                          final scale = 1 + (animation.value * 0.01);
                          return Transform.scale(
                            scale: scale,
                            child: Material(
                              elevation: 4 * animation.value,
                              color: Colors.transparent,
                              shadowColor: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(18),
                              child: child,
                            ),
                          );
                        },
                      );
                    },
                    onReorderStart: (_) {
                      HapticFeedback.heavyImpact();
                    },
                    onReorder: (oldIndex, newIndex) {
                      context.read<NewSessionProvider>().reorderExercise(
                        oldIndex,
                        newIndex,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
