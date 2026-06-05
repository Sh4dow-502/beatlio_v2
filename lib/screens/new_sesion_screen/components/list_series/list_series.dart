import 'package:beatlio_v2/provider/new_session_provider.dart';
import 'package:beatlio_v2/screens/new_sesion_screen/components/list_series/container_serie_reorderable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ListSeries extends StatefulWidget {
  const ListSeries({super.key});

  @override
  State<ListSeries> createState() => _ListSeriesState();
}

class _ListSeriesState extends State<ListSeries> {
  bool reorderMode = false;

  @override
  Widget build(BuildContext context) {
    final listSeries = context.watch<NewSessionProvider>().series;

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
                      "Series",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reorderMode
                          ? "Modo reorder activo"
                          : "Mantén presionado un item para reordenarlo",
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
                  setState(() {
                    reorderMode = !reorderMode;
                  });
                },
                tooltip: "Activar reorder",
                icon: Icon(
                  reorderMode ? Icons.swap_vert : Icons.swap_vert_outlined,
                ),
                style: IconButton.styleFrom(
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
            child: listSeries.isEmpty
                ? Center(
                    child: Text(
                      "No hay series agregadas",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 17,
                      ),
                    ),
                  )
                : ReorderableListView.builder(
                    buildDefaultDragHandles: false,
                    itemCount: listSeries.length,
                    itemBuilder: (context, index) {
                      final serie = listSeries[index];
                      return ContainerSerieReorderable(
                        key: ValueKey(serie.uid),
                        serie: serie,
                        index: index,
                        reorderMode: reorderMode,
                      );
                    },
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
                      context.read<NewSessionProvider>().reorderSerie(
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
