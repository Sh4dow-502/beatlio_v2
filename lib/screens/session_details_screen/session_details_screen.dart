import 'dart:ui';

import 'package:beatlio_v2/models/exercise.dart';
import 'package:beatlio_v2/models/serie.dart';
import 'package:beatlio_v2/models/session.dart';
import 'package:beatlio_v2/provider/home_session_provider.dart';
import 'package:beatlio_v2/provider/new_session_provider.dart';
import 'package:beatlio_v2/provider/session_provider.dart';
import 'package:beatlio_v2/screens/session_screen/session_screen.dart';
import 'package:beatlio_v2/ui/components/icon_drag.dart';
import 'package:beatlio_v2/ui/theme/custom_colors.dart';
import 'package:beatlio_v2/utilities/text_formatters/time_formatter.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class SessionDetailsScreen extends StatefulWidget {
  final Session session;
  const SessionDetailsScreen({super.key, required this.session});

  @override
  State<SessionDetailsScreen> createState() => _SessionDetailsScreenState();
}

class _SessionDetailsScreenState extends State<SessionDetailsScreen> {
  bool _exercisesReorderMode = false;
  bool _seriesReorderMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<NewSessionProvider>().loadSession(widget.session);
    });
  }

  Future<void> _persistSessionOrder() async {
    final result = context.read<NewSessionProvider>().saveSession();
    if (result == 'success') {
      await context.read<HomeSessionProvider>().loadSessions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NewSessionProvider>();
    final exercises = provider.exercises;
    final series = provider.series;

    final Color headerTextColor = Color(0xffffffff);
    final paddingHorizontal = EdgeInsets.symmetric(horizontal: 15);
    return Scaffold(
      headers: [
        AppBar(
          title: Text(
            widget.session.name,
            overflow: TextOverflow.ellipsis,
          ).bold(),
          leading: [
            OutlineButton(
              density: ButtonDensity.icon,
              onPressed: () => Navigator.pop(context),
              size: ButtonSize.small,
              child: Icon(Icons.arrow_back),
            ),
          ],
          trailing: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_vert),
              variance: ButtonStyle.textIcon(),
            ),
          ],
        ),
      ],
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: paddingHorizontal,
                child: Card(
                  padding: EdgeInsets.all(8),
                  fillColor: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                  filled: true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.timer,
                        size: 20,
                        color: headerTextColor,
                      ).muted(),
                      const Gap(5),
                      Text(
                        widget.session.totalTime().toString(),
                      ).xSmall(color: headerTextColor),
                      const Gap(20),
                      Text("•").small().muted(),
                      const Gap(20),
                      Icon(
                        Icons.fitness_center_rounded,
                        size: 20,
                        color: headerTextColor,
                      ).muted(),
                      const Gap(5),
                      Text(
                        "${widget.session.totalExercises().toString()} Ejercicios",
                      ).xSmall(color: headerTextColor),
                    ],
                  ),
                ),
              ),
              const Gap(30),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: paddingHorizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeaderSection(
                          name: "Ejercicios",
                          subtitle: "( ${exercises.length} )",
                          reorderMode: _exercisesReorderMode,
                          onToggleReorder: () {
                            HapticFeedback.heavyImpact();
                            setState(() {
                              _exercisesReorderMode = !_exercisesReorderMode;
                            });
                          },
                        ),
                        ListViewData(
                          data: exercises,
                          type: "exercise",
                          reorderMode: _exercisesReorderMode,
                          onReorder: (oldIndex, newIndex) {
                            context.read<NewSessionProvider>().reorderExercise(
                              oldIndex,
                              newIndex,
                            );
                            _persistSessionOrder();
                          },
                        ),
                        const Gap(20),
                        const Divider(),
                        const Gap(20),
                        HeaderSection(
                          name: "Series",
                          subtitle:
                              "( ${series.length} )   •   ${widget.session.totalExerciseInSerie()} Ejercicios",
                          reorderMode: _seriesReorderMode,
                          onToggleReorder: () {
                            HapticFeedback.heavyImpact();
                            setState(() {
                              _seriesReorderMode = !_seriesReorderMode;
                            });
                          },
                        ),
                        ListViewData(
                          data: series,
                          type: "serie",
                          reorderMode: _seriesReorderMode,
                          onPersist: _persistSessionOrder,
                          onReorder: (oldIndex, newIndex) {
                            context.read<NewSessionProvider>().reorderSerie(
                              oldIndex,
                              newIndex,
                            );
                            _persistSessionOrder();
                          },
                        ),
                        const Gap(110),
                      ],
                    ),
                  ),
                ),
              ),
              const Gap(20),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.background.withValues(alpha: 0.3),
                  ),
                  padding: const EdgeInsets.only(
                    bottom: 50,
                    top: 0,
                    left: 15,
                    right: 15,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            // SessionProvider().setExercises(
                            //   widget.session.exercises,
                            // );

                            context.read<SessionProvider>().setSeries(series);
                            context.read<SessionProvider>().setTotalExercises(
                              widget.session.totalExercises(),
                            );
                            context.read<SessionProvider>().setRestTimeSeconds(
                              widget.session.restDuration,
                            );
                            context.read<SessionProvider>().setExercises(
                              exercises,
                            );
                            return SessionScreen(session: widget.session);
                          },
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.all(17),
                      child: Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(LucideIcons.play),
                          Text("Comenzar Práctica").small().medium(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  final String name;
  final String subtitle;
  final bool reorderMode;
  final VoidCallback onToggleReorder;

  const HeaderSection({
    super.key,
    required this.name,
    required this.subtitle,
    required this.reorderMode,
    required this.onToggleReorder,
  });

  @override
  Widget build(BuildContext context) {
    final Color sectionTitleColor = Color(0xFFffffff);
    final Color sectionSubtitleColor = sectionTitleColor.withValues(alpha: .8);
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Row(
      children: [
        Text(name).medium().small(color: sectionTitleColor),
        const Gap(5),
        Text(subtitle).xSmall(color: sectionSubtitleColor).muted(),
        const Spacer(),
        IconButton(
          onPressed: onToggleReorder,
          icon: Icon(
            reorderMode ? Icons.swap_vert_rounded : Icons.swap_vert_outlined,
            color: reorderMode
                ? primaryColor
                : Colors.white.withValues(alpha: 0.8),
          ),
          density: ButtonDensity.dense,
          variance: ButtonStyle.textIcon(),
        ),
      ],
    );
  }
}

class ListViewData extends StatelessWidget {
  final List<Object> data;
  final String type;
  final bool reorderMode;
  final void Function(int oldIndex, int newIndex) onReorder;
  final VoidCallback? onPersist;

  const ListViewData({
    super.key,
    required this.data,
    required this.type,
    required this.reorderMode,
    required this.onReorder,
    this.onPersist,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          type == "exercise"
              ? "No hay ejercicios agregados"
              : "No hay series agregadas",
        ).xSmall(color: Colors.white.withValues(alpha: 0.5)),
      );
    }

    return material.ReorderableListView.builder(
      shrinkWrap: true,
      physics: const material.NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 10),
      buildDefaultDragHandles: false,
      itemCount: data.length,
      proxyDecorator: (child, index, animation) {
        return AnimatedBuilder(
          animation: animation,
          child: child,
          builder: (context, child) {
            final scale = 1 + (animation.value * 0.01);
            return Transform.scale(
              scale: scale,
              child: material.Material(
                elevation: 4 * animation.value,
                color: material.Colors.transparent,
                shadowColor: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                child: child,
              ),
            );
          },
        );
      },
      onReorderStart: (_) {
        HapticFeedback.heavyImpact();
      },
      onReorder: onReorder,
      itemBuilder: (context, index) {
        final item = data[index];

        if (type == "exercise" && item is Exercise) {
          final card = ContainerDetailExercise(exercise: item);
          return _buildReorderableRow(
            key: material.ValueKey(item.uid),
            index: index,
            reorderMode: reorderMode,
            child: card,
          );
        }

        final serie = item as Serie;
        final card = ContainerDetailSerie(serie: serie, onPersist: onPersist);
        return _buildReorderableRow(
          key: material.ValueKey(serie.uid),
          index: index,
          reorderMode: reorderMode,
          child: card,
        );
      },
    );
  }

  Widget _buildReorderableRow({
    required Key key,
    required int index,
    required bool reorderMode,
    required Widget child,
  }) {
    if (reorderMode) {
      return Row(
        key: key,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: child),
          const Gap(8),
          material.ReorderableDragStartListener(
            index: index,
            child: IconDrag(iconColor: Colors.white.withValues(alpha: 0.2)),
          ),
        ],
      );
    }

    return material.ReorderableDelayedDragStartListener(
      key: key,
      index: index,
      child: child,
    );
  }
}

class ContainerDetailExercise extends StatelessWidget {
  const ContainerDetailExercise({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff181818),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.secondary),
      ),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(exercise.name).small().medium(),
              const Gap(5),
              Row(
                children: [
                  Text(
                    formatDuration(exercise.duration),
                    overflow: TextOverflow.ellipsis,
                  ).xSmall(color: Colors.white.withValues(alpha: 0.7)),
                  const Gap(10),
                  Text(
                    "${exercise.bpm} bpm",
                    overflow: TextOverflow.ellipsis,
                  ).xSmall(color: Colors.white.withValues(alpha: 0.7)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ListExerciseInSerieDetail extends StatelessWidget {
  final Serie serie;
  final VoidCallback? onPersist;

  const ListExerciseInSerieDetail({
    super.key,
    required this.serie,
    this.onPersist,
  });

  @override
  Widget build(BuildContext context) {
    if (serie.exercises.isEmpty) {
      return const SizedBox.shrink();
    }

    return material.ReorderableListView.builder(
      shrinkWrap: true,
      physics: const material.NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: false,
      padding: EdgeInsets.zero,
      itemCount: serie.exercises.length,
      onReorderStart: (_) {
        HapticFeedback.heavyImpact();
      },
      // onReorderItem: ,
      onReorder: (oldIndex, newIndex) {
        context.read<NewSessionProvider>().reorderExerciseInSerieByUid(
          serie.uid,
          oldIndex,
          newIndex,
        );
        onPersist?.call();
      },
      itemBuilder: (context, index) {
        final exercise = serie.exercises[index];
        return Padding(
          key: material.ValueKey(exercise.uid),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              const Gap(10),
              Text("•").muted(),
              const Gap(15),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(exercise.name).xSmall().medium(),
                    const Spacer(),
                    Text(
                      formatDuration(exercise.duration),
                    ).xSmall(color: Colors.white.withValues(alpha: 0.7)),
                    const Gap(10),
                    Text(
                      "${exercise.bpm} bpm",
                    ).xSmall(color: Colors.white.withValues(alpha: 0.7)),
                  ],
                ),
              ),
              material.ReorderableDragStartListener(
                index: index,
                child: IconDrag(iconColor: Colors.white.withValues(alpha: 0.2)),
              ),
              const Gap(10),
            ],
          ),
        );
      },
    );
  }
}

class ContainerDetailSerie extends StatelessWidget {
  const ContainerDetailSerie({super.key, required this.serie, this.onPersist});

  final Serie serie;
  final VoidCallback? onPersist;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.containerColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.secondary),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      margin: EdgeInsets.only(bottom: 10),
      child: Accordion(
        items: [
          AccordionItem(
            trigger: AccordionTrigger(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            serie.name,
                            overflow: TextOverflow.ellipsis,
                          ).small().medium(),
                        ],
                      ),
                      const Gap(5),
                      Row(
                        children: [
                          Text(
                            "${serie.totalExercises()} Ejercicio${serie.totalExercises() > 1 ? "s" : ""}",
                            overflow: TextOverflow.ellipsis,
                          ).xSmall(color: Colors.white.withValues(alpha: 0.7)),
                          const Gap(5),
                          Text(
                            "•",
                          ).xSmall(color: Colors.white.withValues(alpha: 0.7)),
                          const Gap(5),
                          Text(
                            formatDuration(serie.totalTimeInSeconds()),
                          ).xSmall(color: Colors.white.withValues(alpha: 0.7)),
                          if (serie.bpmGlobal) ...[
                            const Gap(5),
                            Text("•").xSmall(
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                            const Gap(5),
                            Text("${serie.bpmValueGlobal} bpm").xSmall(
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            content: Column(
              children: [
                Divider(),
                const Gap(10),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xff202020),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    spacing: 10,
                    children: [
                      const Gap(1),
                      ListExerciseInSerieDetail(
                        serie: serie,
                        onPersist: onPersist,
                      ),
                      const Gap(1),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
