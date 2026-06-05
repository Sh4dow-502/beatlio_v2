import 'package:beatlio_v2/ui/theme/custom_colors.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class DotBpm extends StatefulWidget {
  final bool isAccentuated;
  final bool isSelected;
  final VoidCallback? onTap;

  const DotBpm({
    super.key,
    this.isAccentuated = false,
    this.isSelected = false,
    this.onTap,
  });

  @override
  State<DotBpm> createState() => _DotBpmState();
}

class _DotBpmState extends State<DotBpm> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    if (widget.isSelected) {
      _pulseController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant DotBpm oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isSelected && !oldWidget.isSelected) {
      _pulseController.forward(from: 0);
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _pulseController.reverse(from: 1);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final accentColor = CustomColors.purple;
    final selectedColor = colors.primary;
    final baseColor = widget.isAccentuated ? accentColor : colors.secondary;
    final activeColor = widget.isAccentuated ? accentColor : selectedColor;
    final restingOpacity = widget.isAccentuated ? 0.46 : 0.7;
    final restingBorderOpacity = widget.isAccentuated ? 0.34 : 0.55;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final pulseT = Curves.easeOutCubic.transform(_pulseController.value);
          final scale = widget.isSelected ? 0.82 + (pulseT * 0.22) : 1.0;
          final glowOpacity = widget.isSelected ? 0.2 + (pulseT * 0.22) : 0.0;

          return Transform.scale(
            scale: scale,
            child: SizedBox(
              width: 52,
              height: 52,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 160),
                    opacity: glowOpacity,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: activeColor.withValues(alpha: 0.18),
                        boxShadow: [
                          BoxShadow(
                            color: activeColor.withValues(alpha: 0.14),
                            blurRadius: 18,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.isSelected
                            ? activeColor
                            : baseColor.withValues(alpha: restingBorderOpacity),
                        width: widget.isSelected ? 1.4 : 1.1,
                      ),
                      color: widget.isSelected
                          ? activeColor
                          : baseColor.withValues(alpha: restingOpacity),
                      boxShadow: widget.isSelected
                          ? [
                              BoxShadow(
                                color: activeColor.withValues(alpha: 0.22),
                                blurRadius: 14,
                                spreadRadius: 0.5,
                                offset: const Offset(0, 4),
                              ),
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.06),
                                blurRadius: 3,
                                spreadRadius: 0,
                                offset: const Offset(0, -1),
                              ),
                            ]
                          : const [],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
