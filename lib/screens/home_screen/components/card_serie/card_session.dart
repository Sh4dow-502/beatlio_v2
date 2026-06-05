import 'package:shadcn_flutter/shadcn_flutter.dart';

class CardSession extends StatelessWidget {
  final String name;
  final String totalTime;
  final int totalExercises;
  final Function()? onTap;

  const CardSession({
    super.key,
    required this.name,
    required this.totalTime,
    required this.totalExercises,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      filled: true,
      fillColor: colors.secondary.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(22),
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name).semiBold(),
              const Gap(10),
              Row(
                children: [
                  _InfoPill(icon: LucideIcons.timer, label: totalTime),
                  const Gap(5),
                  Text("•").xSmall().muted(),
                  const Gap(5),
                  _InfoPill(
                    icon: Icons.fitness_center_rounded,
                    label: "$totalExercises Ejercicios",
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.chevron_right_rounded),
            variance: ButtonStyle.textIcon(),
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colors.mutedForeground),
          const Gap(3),
          Text(label).xSmall().muted(),
        ],
      ),
    );
  }
}
