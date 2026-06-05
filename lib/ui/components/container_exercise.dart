import 'package:beatlio_v2/models/exercise.dart';
import 'package:beatlio_v2/ui/theme/custom_colors.dart';
import 'package:beatlio_v2/utilities/text_formatters/time_formatter.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ContainerExercise extends StatelessWidget {
  final Function()? onEdit;
  final Function()? onDelete;
  final int index;
  final Widget? leadingIconDrag;
  final Color? bgColor;
  final bool isSerie;
  final bool globalBpm;

  const ContainerExercise({
    super.key,
    required this.exercise,
    required this.index,
    this.leadingIconDrag,
    this.onEdit,
    this.onDelete,
    this.bgColor,
    this.isSerie = false,
    this.globalBpm = true,
  });

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.gray.withValues(alpha: 0.15),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(18),
        color: bgColor ?? CustomColors.containerColor,
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          leadingIconDrag ?? SizedBox.shrink(),
          leadingIconDrag != null ? const Gap(12) : SizedBox.shrink(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(exercise.name),
              const Gap(5),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.access_time,
                    size: 15,
                    color: Colors.white.withValues(alpha: 0.6),
                  ).xSmall().muted(),
                  Text(formatDuration(exercise.duration)).xSmall().muted(),
                  const Gap(10),

                  if (isSerie == false && globalBpm == true)
                    Icon(
                      CupertinoIcons.metronome,
                      size: 15,
                      color: Colors.white.withValues(alpha: 0.6),
                    ).xSmall().muted(),

                  // if (isSerie && !globalBpm)
                  if (isSerie == false && globalBpm == true)
                    Text("${exercise.bpm} bpm").xSmall().muted(),
                ],
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.white.withValues(alpha: 0.35),
                ),
                variance: ButtonStyle.textIcon(),
                density: ButtonDensity.dense,
                size: ButtonSize.small,
                onPressed: onEdit,
              ),
              const Gap(15),
              IconButton(
                icon: Icon(
                  Icons.delete_rounded,
                  color: Colors.white.withValues(alpha: 0.35),
                ),
                variance: ButtonStyle.textIcon(),
                density: ButtonDensity.dense,
                size: ButtonSize.small,
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
