import 'package:beatlio_v2/models/session.dart';
import 'package:beatlio_v2/ui/theme/custom_colors.dart';
import 'package:beatlio_v2/utilities/text_formatters/time_formatter.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class SessionDetailsScreen extends StatelessWidget {
  final Session session;
  const SessionDetailsScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [
        AppBar(
          title: Text(session.name, overflow: TextOverflow.ellipsis).bold(),
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
              icon: Icon(Icons.edit),
              variance: ButtonStyle.textIcon(),
              // density: ButtonDensity.compact,
              size: ButtonSize.small,
            ),
          ],
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      padding: EdgeInsets.all(15),
                      borderRadius: BorderRadius.circular(18),
                      fillColor: CustomColors.containerColor2,
                      filled: true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(LucideIcons.timer, size: 20).muted(),
                          const Gap(5),
                          Text(session.totalTime().toString()).xSmall(),
                          const Gap(20),
                          Text("•").small().muted(),
                          const Gap(20),
                          const Icon(
                            Icons.fitness_center_rounded,
                            size: 20,
                          ).muted(),
                          const Gap(5),
                          Text(
                            "${session.totalExercises().toString()} Ejercicios",
                          ).xSmall(),
                        ],
                      ),
                    ),
                    const Gap(10),
                    Row(
                      children: [
                        Text("Ejercicios").small().medium(),
                        Spacer(),
                        Text("${session.exercises.length}").xSmall().muted(),
                      ],
                    ),
                    ListView.builder(
                      itemCount: session.exercises.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(top: 10),
                      itemBuilder: (context, index) {
                        final exercise = session.exercises[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: CustomColors.containerColor2,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(exercise.name).small().medium(),
                              const Gap(5),
                              Row(
                                children: [
                                  Text(
                                    formatDuration(exercise.duration),
                                  ).xSmall().muted(),
                                  const Gap(10),
                                  Text("${exercise.bpm} BPM").xSmall().muted(),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Row(
                      children: [
                        Text("Series").small().medium(),
                        Spacer(),
                        Text("${session.series.length}").xSmall().muted(),
                      ],
                    ),
                    ListView.builder(
                      itemCount: session.series.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(top: 10),
                      itemBuilder: (context, index) {
                        final serie = session.series[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: CustomColors.containerColor2,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(serie.name).small().medium(),
                              const Gap(5),
                              Text(
                                "${serie.exercises.length} Ejercicios",
                              ).xSmall().muted(),
                              const Gap(5),
                              Row(
                                children: [
                                  if (serie.bpmGlobal)
                                    Text(
                                      "BPM Global: ${serie.bpmValueGlobal}",
                                    ).xSmall().muted(),
                                  if (serie.durationGlobal)
                                    Row(
                                      children: [
                                        const Gap(10),
                                        Text(
                                          "Duración Global: ${formatDuration(serie.durationValueGlobal!)}",
                                        ).xSmall().muted(),
                                      ],
                                    ),
                                  // Text("")
                                  // Text("${series.bpm} BPM").xSmall().muted(),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // appBar: AppBar(title: const Text('Session Detail')),
      // body: const Center(child: Text('Session details will be shown here.')),
    );
  }
}
